module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MODEL


type alias Model =
    { activeSection : String
    , mobileMenuOpen : Bool
    , contactForm : ContactForm
    , formErrors : FormErrors
    , isSubmitting : Bool
    , submitMessage : Maybe String
    , currentTestimonial : Int
    }


type alias ContactForm =
    { name : String
    , email : String
    , phone : String
    , address : String
    , message : String
    }


type alias FormErrors =
    { name : Maybe String
    , email : Maybe String
    , phone : Maybe String
    , address : Maybe String
    , message : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { activeSection = "home"
      , mobileMenuOpen = False
      , contactForm = { name = "", email = "", phone = "", address = "", message = "" }
      , formErrors = { name = Nothing, email = Nothing, phone = Nothing, address = Nothing, message = Nothing }
      , isSubmitting = False
      , submitMessage = Nothing
      , currentTestimonial = 0
      }
    , Cmd.none
    )


-- UPDATE


type Msg
    = SetActiveSection String
    | ToggleMobileMenu
    | UpdateContactForm String String
    | SubmitContactForm
    | ContactFormSubmitted (Result Http.Error String)
    | ClearSubmitMessage
    | NextTestimonial
    | PrevTestimonial


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetActiveSection section ->
            ( { model | activeSection = section, mobileMenuOpen = False }, Cmd.none )

        ToggleMobileMenu ->
            ( { model | mobileMenuOpen = not model.mobileMenuOpen }, Cmd.none )

        UpdateContactForm field value ->
            let
                updatedForm =
                    case field of
                        "name" ->
                            { name = value, email = model.contactForm.email, phone = model.contactForm.phone, address = model.contactForm.address, message = model.contactForm.message }

                        "email" ->
                            { name = model.contactForm.name, email = value, phone = model.contactForm.phone, address = model.contactForm.address, message = model.contactForm.message }

                        "phone" ->
                            { name = model.contactForm.name, email = model.contactForm.email, phone = value, address = model.contactForm.address, message = model.contactForm.message }

                        "address" ->
                            { name = model.contactForm.name, email = model.contactForm.email, phone = model.contactForm.phone, address = value, message = model.contactForm.message }

                        "message" ->
                            { name = model.contactForm.name, email = model.contactForm.email, phone = model.contactForm.phone, address = model.contactForm.address, message = value }

                        _ ->
                            model.contactForm

                clearedErrors =
                    case field of
                        "name" ->
                            { name = Nothing, email = model.formErrors.email, phone = model.formErrors.phone, address = model.formErrors.address, message = model.formErrors.message }

                        "email" ->
                            { name = model.formErrors.name, email = Nothing, phone = model.formErrors.phone, address = model.formErrors.address, message = model.formErrors.message }

                        "phone" ->
                            { name = model.formErrors.name, email = model.formErrors.email, phone = Nothing, address = model.formErrors.address, message = model.formErrors.message }

                        "address" ->
                            { name = model.formErrors.name, email = model.formErrors.email, phone = model.formErrors.phone, address = Nothing, message = model.formErrors.message }

                        "message" ->
                            { name = model.formErrors.name, email = model.formErrors.email, phone = model.formErrors.phone, address = model.formErrors.address, message = Nothing }

                        _ ->
                            model.formErrors
            in
            ( { model | contactForm = updatedForm, formErrors = clearedErrors }, Cmd.none )

        SubmitContactForm ->
            let
                errors =
                    validateForm model.contactForm
            in
            if hasErrors errors then
                ( { model | formErrors = errors }, Cmd.none )

            else
                ( { model | isSubmitting = True, formErrors = { name = Nothing, email = Nothing, phone = Nothing, address = Nothing, message = Nothing } }
                , submitForm model.contactForm
                )

        ContactFormSubmitted result ->
            case result of
                Ok _ ->
                    ( { model
                        | isSubmitting = False
                        , submitMessage = Just "Thank you! We'll contact you soon to set up your service."
                        , contactForm = { name = "", email = "", phone = "", address = "", message = "" }
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                        | isSubmitting = False
                        , submitMessage = Just "There was an error sending your message. Please try again or call us directly."
                      }
                    , Cmd.none
                    )

        ClearSubmitMessage ->
            ( { model | submitMessage = Nothing }, Cmd.none )

        NextTestimonial ->
            ( { model | currentTestimonial = modBy (List.length testimonials) (model.currentTestimonial + 1) }, Cmd.none )

        PrevTestimonial ->
            let
                newIndex =
                    if model.currentTestimonial == 0 then
                        List.length testimonials - 1

                    else
                        model.currentTestimonial - 1
            in
            ( { model | currentTestimonial = newIndex }, Cmd.none )


-- VALIDATION


validateForm : ContactForm -> FormErrors
validateForm form =
    { name =
        if String.trim form.name == "" then
            Just "Name is required"

        else
            Nothing
    , email =
        if String.trim form.email == "" then
            Just "Email is required"

        else if not (isValidEmail form.email) then
            Just "Please enter a valid email"

        else
            Nothing
    , phone =
        if String.trim form.phone == "" then
            Just "Phone number is required"

        else
            Nothing
    , address =
        if String.trim form.address == "" then
            Just "Service address is required"

        else
            Nothing
    , message = Nothing
    }


hasErrors : FormErrors -> Bool
hasErrors errors =
    errors.name /= Nothing || errors.email /= Nothing || errors.phone /= Nothing || errors.address /= Nothing || errors.message /= Nothing


isValidEmail : String -> Bool
isValidEmail email =
    String.contains "@" email && String.contains "." email


-- HTTP


submitForm : ContactForm -> Cmd Msg
submitForm form =
    -- Simulate form submission
    Http.get
        { url = "https://httpbin.org/delay/1"
        , expect = Http.expectString ContactFormSubmitted
        }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- DATA


type alias Testimonial =
    { name : String
    , location : String
    , content : String
    , rating : Int
    , avatar : String
    }


testimonials : List Testimonial
testimonials =
    [ { name = "Sarah Johnson"
      , location = "Oceanside, CA"
      , content = "EliteBins has been a game-changer for our family! No more forgetting to take out the trash or dragging bins back up our long driveway. The service is reliable and affordable."
      , rating = 5
      , avatar = "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=400"
      }
    , { name = "Michael Chen"
      , location = "Vista, CA"
      , content = "I travel frequently for work and was always worried about missing trash day. EliteBins takes care of everything - I never have to think about it anymore!"
      , rating = 5
      , avatar = "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400"
      }
    , { name = "Emily Rodriguez"
      , location = "Escondido, CA"
      , content = "As a busy mom of three, EliteBins saves me so much time and hassle. The team is professional, punctual, and reasonably priced. Highly recommend!"
      , rating = 5
      , avatar = "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400"
      }
    ]


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , case model.activeSection of
            "home" ->
                div []
                    [ viewHero
                    , viewServices
                    , viewTestimonials model
                    ]

            "about" ->
                viewAbout

            "contact" ->
                viewContact model

            _ ->
                div []
                    [ viewHero
                    , viewServices
                    , viewTestimonials model
                    ]
        , viewFooter
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    header [ class "fixed top-0 left-0 right-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-200 shadow-sm" ]
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "flex items-center justify-between h-16" ]
                [ -- Logo
                  div [ class "flex items-center" ]
                    [ div [ class "flex-shrink-0" ]
                        [ h1 [ class "text-2xl font-bold text-green-600" ]
                            [ text "🗑️ EliteBins" ]
                        ]
                    ]
                , -- Desktop Navigation
                  nav [ class "hidden md:block" ]
                    [ div [ class "ml-10 flex items-baseline space-x-4" ]
                        [ navButton "home" "Home" model.activeSection
                        , navButton "about" "About" model.activeSection
                        , navButton "contact" "Get Started" model.activeSection
                        ]
                    ]
                , -- Contact Info
                  div [ class "hidden md:flex items-center space-x-4" ]
                    [ div [ class "text-sm text-gray-600" ]
                        [ text "📞 (760) 892-1716" ]
                    ]
                , -- Mobile menu button
                  div [ class "md:hidden" ]
                    [ button
                        [ class "inline-flex items-center justify-center p-2 rounded-md text-gray-600 hover:text-green-600 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-green-500"
                        , onClick ToggleMobileMenu
                        ]
                        [ text (if model.mobileMenuOpen then "✕" else "☰") ]
                    ]
                ]
            , -- Mobile Navigation
              if model.mobileMenuOpen then
                div [ class "md:hidden" ]
                    [ div [ class "px-2 pt-2 pb-3 space-y-1 sm:px-3 bg-white border-t border-gray-200" ]
                        [ mobileNavButton "home" "Home" model.activeSection
                        , mobileNavButton "about" "About" model.activeSection
                        , mobileNavButton "contact" "Get Started" model.activeSection
                        , div [ class "px-3 py-2 text-sm text-gray-600" ]
                            [ text "📞 (760) 892-1716" ]
                        ]
                    ]

              else
                text ""
            ]
        ]


navButton : String -> String -> String -> Html Msg
navButton section label activeSection =
    button
        [ class ("px-3 py-2 rounded-md text-sm font-medium transition-colors " ++ (if activeSection == section then "bg-green-100 text-green-700" else "text-gray-600 hover:text-green-600 hover:bg-gray-50"))
        , onClick (SetActiveSection section)
        ]
        [ text label ]


mobileNavButton : String -> String -> String -> Html Msg
mobileNavButton section label activeSection =
    button
        [ class ("block px-3 py-2 rounded-md text-base font-medium w-full text-left transition-colors " ++ (if activeSection == section then "bg-green-100 text-green-700" else "text-gray-600 hover:text-green-600 hover:bg-gray-50"))
        , onClick (SetActiveSection section)
        ]
        [ text label ]


viewHero : Html Msg
viewHero =
    section [ class "pt-16 pb-20 bg-gradient-to-br from-green-50 to-blue-50" ]
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "text-center" ]
                [ div [ class "max-w-4xl mx-auto" ]
                    [ h1 [ class "text-4xl md:text-6xl font-bold text-gray-900 mb-6" ]
                        [ text "One Less Thing"
                        , br [] []
                        , span [ class "text-green-600" ] [ text "To Worry About" ]
                        ]
                    , p [ class "text-xl md:text-2xl text-gray-600 mb-8 leading-relaxed" ]
                        [ text "We take your bins out and bring them back in, so you don't have to. Reliable, convenient, and hassle-free waste management for busy homeowners." ]
                    , div [ class "flex flex-col sm:flex-row gap-4 justify-center items-center" ]
                        [ button
                            [ class "px-8 py-4 bg-green-600 text-white text-lg font-semibold rounded-lg hover:bg-green-700 transition-colors shadow-lg"
                            , onClick (SetActiveSection "contact")
                            ]
                            [ text "Get Started Today" ]
                        , div [ class "text-gray-600" ]
                            [ text "📞 Call us: (760) 892-1716" ]
                        ]
                    ]
                ]
            , -- Hero Image/Illustration
              div [ class "mt-16 text-center" ]
                [ div [ class "inline-block p-8 bg-white rounded-2xl shadow-xl" ]
                    [ div [ class "text-8xl mb-4" ] [ text "🗑️" ]
                    , p [ class "text-gray-600 font-medium" ] [ text "We handle your bins so you don't have to!" ]
                    ]
                ]
            ]
        ]


viewServices : Html Msg
viewServices =
    section [ class "py-20 bg-white" ]
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "text-center mb-16" ]
                [ h2 [ class "text-3xl md:text-4xl font-bold text-gray-900 mb-4" ]
                    [ text "How It Works" ]
                , p [ class "text-xl text-gray-600 max-w-3xl mx-auto" ]
                    [ text "Simple, reliable service that fits seamlessly into your routine" ]
                ]
            , div [ class "grid grid-cols-1 md:grid-cols-3 gap-8" ]
                [ serviceCard "1" "🏠" "We Come to You" "Every trash day, we arrive at your home before pickup time"
                , serviceCard "2" "🚛" "Handle Everything" "We take your bins to the curb and bring them back after pickup"
                , serviceCard "3" "😌" "You Relax" "Never worry about missing trash day or dragging bins again"
                ]
            , div [ class "mt-16 bg-green-50 rounded-2xl p-8 text-center" ]
                [ h3 [ class "text-2xl font-bold text-gray-900 mb-4" ]
                    [ text "Why Choose EliteBins?" ]
                , div [ class "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6" ]
                    [ benefitItem "⏰" "Always On Time" "Reliable service every pickup day"
                    , benefitItem "💰" "Affordable" "Starting at just $15/month"
                    , benefitItem "🔒" "Fully Insured" "Licensed and bonded for your peace of mind"
                    , benefitItem "📱" "Easy Management" "Simple communication and scheduling"
                    ]
                ]
            ]
        ]


serviceCard : String -> String -> String -> String -> Html Msg
serviceCard step icon title description =
    div [ class "text-center" ]
        [ div [ class "inline-flex items-center justify-center w-16 h-16 bg-green-100 text-green-600 rounded-full text-2xl font-bold mb-4" ]
            [ text step ]
        , div [ class "text-4xl mb-4" ] [ text icon ]
        , h3 [ class "text-xl font-semibold text-gray-900 mb-2" ]
            [ text title ]
        , p [ class "text-gray-600" ]
            [ text description ]
        ]


benefitItem : String -> String -> String -> Html Msg
benefitItem icon title description =
    div [ class "text-center" ]
        [ div [ class "text-3xl mb-2" ] [ text icon ]
        , h4 [ class "font-semibold text-gray-900 mb-1" ] [ text title ]
        , p [ class "text-sm text-gray-600" ] [ text description ]
        ]


viewTestimonials : Model -> Html Msg
viewTestimonials model =
    section [ class "py-20 bg-gray-50" ]
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "text-center mb-16" ]
                [ h2 [ class "text-3xl md:text-4xl font-bold text-gray-900 mb-4" ]
                    [ text "What Our Customers Say" ]
                , p [ class "text-xl text-gray-600" ]
                    [ text "Join hundreds of satisfied customers across North County San Diego" ]
                ]
            , div [ class "relative max-w-4xl mx-auto" ]
                [ case List.drop model.currentTestimonial testimonials |> List.head of
                    Just testimonial ->
                        viewTestimonialCard testimonial

                    Nothing ->
                        text ""
                , div [ class "flex justify-center items-center space-x-4 mt-8" ]
                    [ button
                        [ class "p-3 rounded-full bg-white shadow-md hover:shadow-lg transition-shadow text-gray-600 hover:text-green-600"
                        , onClick PrevTestimonial
                        ]
                        [ text "‹" ]
                    , div [ class "flex space-x-2" ]
                        (List.indexedMap (viewTestimonialIndicator model.currentTestimonial) testimonials)
                    , button
                        [ class "p-3 rounded-full bg-white shadow-md hover:shadow-lg transition-shadow text-gray-600 hover:text-green-600"
                        , onClick NextTestimonial
                        ]
                        [ text "›" ]
                    ]
                ]
            ]
        ]


viewTestimonialCard : Testimonial -> Html Msg
viewTestimonialCard testimonial =
    div [ class "bg-white rounded-2xl shadow-xl p-8 mx-4" ]
        [ div [ class "flex items-center mb-6" ]
            [ img
                [ src testimonial.avatar
                , alt testimonial.name
                , class "w-16 h-16 rounded-full mr-4"
                ]
                []
            , div []
                [ h4 [ class "font-semibold text-gray-900" ] [ text testimonial.name ]
                , p [ class "text-gray-600" ] [ text testimonial.location ]
                , div [ class "flex mt-1" ]
                    (List.repeat testimonial.rating (span [ class "text-yellow-400" ] [ text "★" ]))
                ]
            ]
        , blockquote [ class "text-lg text-gray-700 italic leading-relaxed" ]
            [ text ("\"" ++ testimonial.content ++ "\"") ]
        ]


viewTestimonialIndicator : Int -> Int -> Testimonial -> Html Msg
viewTestimonialIndicator currentIndex index testimonial =
    button
        [ class ("w-3 h-3 rounded-full transition-colors " ++ (if currentIndex == index then "bg-green-600" else "bg-gray-300"))
        ]
        []


viewAbout : Html Msg
viewAbout =
    section [ class "pt-20 pb-20 bg-white" ]
        [ div [ class "max-w-4xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "text-center mb-16" ]
                [ h1 [ class "text-4xl md:text-5xl font-bold text-gray-900 mb-6" ]
                    [ text "About EliteBins" ]
                , p [ class "text-xl text-gray-600 leading-relaxed" ]
                    [ text "We're a local North County San Diego business dedicated to making your life easier, one bin at a time." ]
                ]
            , div [ class "prose prose-lg mx-auto" ]
                [ div [ class "bg-green-50 rounded-2xl p-8 mb-8" ]
                    [ h2 [ class "text-2xl font-bold text-gray-900 mb-4" ]
                        [ text "Our Mission" ]
                    , p [ class "text-gray-700 mb-4" ]
                        [ text "At EliteBins, we believe that small conveniences can make a big difference in your daily life. Our mission is simple: to provide reliable, affordable bin management services that give you back your time and peace of mind." ]
                    , p [ class "text-gray-700" ]
                        [ text "Whether you're a busy professional, a parent juggling multiple responsibilities, or someone who simply wants one less thing to worry about, we're here to help." ]
                    ]
                , div [ class "grid grid-cols-1 md:grid-cols-2 gap-8 mb-8" ]
                    [ div [ class "bg-blue-50 rounded-xl p-6" ]
                        [ h3 [ class "text-xl font-semibold text-gray-900 mb-3" ]
                            [ text "🏆 Why We Started" ]
                        , p [ class "text-gray-700" ]
                            [ text "Founded by local residents who understand the challenges of maintaining a home while balancing work and family life. We saw a need for reliable, trustworthy service in our community." ]
                        ]
                    , div [ class "bg-yellow-50 rounded-xl p-6" ]
                        [ h3 [ class "text-xl font-semibold text-gray-900 mb-3" ]
                            [ text "🌟 Our Values" ]
                        , ul [ class "text-gray-700 space-y-2" ]
                            [ li [] [ text "• Reliability you can count on" ]
                            , li [] [ text "• Honest, transparent pricing" ]
                            , li [] [ text "• Respect for your property" ]
                            , li [] [ text "• Supporting our local community" ]
                            ]
                        ]
                    ]
                , div [ class "text-center bg-gray-50 rounded-2xl p-8" ]
                    [ h3 [ class "text-2xl font-bold text-gray-900 mb-4" ]
                        [ text "Serving North County San Diego" ]
                    , p [ class "text-gray-700 mb-6" ]
                        [ text "We proudly serve Oceanside, Vista, Escondido, Carlsbad, and surrounding areas. As your neighbors, we're committed to providing the kind of service we'd want for our own families." ]
                    , button
                        [ class "px-8 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition-colors"
                        , onClick (SetActiveSection "contact")
                        ]
                        [ text "Get Started Today" ]
                    ]
                ]
            ]
        ]


viewContact : Model -> Html Msg
viewContact model =
    section [ class "pt-20 pb-20 bg-gradient-to-br from-green-50 to-blue-50" ]
        [ div [ class "max-w-4xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "text-center mb-16" ]
                [ h1 [ class "text-4xl md:text-5xl font-bold text-gray-900 mb-6" ]
                    [ text "Get Started Today" ]
                , p [ class "text-xl text-gray-600" ]
                    [ text "Ready to never worry about your bins again? Let's set up your service!" ]
                ]
            , div [ class "bg-white rounded-2xl shadow-xl p-8" ]
                [ Html.form [ onSubmit SubmitContactForm, class "space-y-6" ]
                    [ div [ class "grid grid-cols-1 md:grid-cols-2 gap-6" ]
                        [ viewFormField "name" "Full Name" "John Doe" model.contactForm.name model.formErrors.name
                        , viewFormField "email" "Email Address" "john@example.com" model.contactForm.email model.formErrors.email
                        ]
                    , div [ class "grid grid-cols-1 md:grid-cols-2 gap-6" ]
                        [ viewFormField "phone" "Phone Number" "(760) 555-0123" model.contactForm.phone model.formErrors.phone
                        , viewFormField "address" "Service Address" "123 Main St, Oceanside, CA" model.contactForm.address model.formErrors.address
                        ]
                    , viewTextareaField "message" "Additional Information (Optional)" "Any special instructions or questions..." model.contactForm.message model.formErrors.message
                    , div [ class "text-center" ]
                        [ button
                            [ type_ "submit"
                            , class ("px-8 py-4 bg-green-600 text-white text-lg font-semibold rounded-lg hover:bg-green-700 transition-colors shadow-lg " ++ (if model.isSubmitting then "opacity-50 cursor-not-allowed" else ""))
                            , disabled model.isSubmitting
                            ]
                            [ text (if model.isSubmitting then "Sending..." else "Start My Service 🚀") ]
                        ]
                    , case model.submitMessage of
                        Just message ->
                            div [ class "text-center p-4 bg-green-100 text-green-800 rounded-lg border border-green-200" ]
                                [ text message
                                , button
                                    [ class "ml-4 text-green-600 hover:text-green-800 font-semibold"
                                    , onClick ClearSubmitMessage
                                    ]
                                    [ text "✕" ]
                                ]

                        Nothing ->
                            text ""
                    ]
                ]
            , div [ class "mt-12 grid grid-cols-1 md:grid-cols-2 gap-8" ]
                [ div [ class "bg-white rounded-xl shadow-lg p-6 text-center" ]
                    [ div [ class "text-4xl mb-4" ] [ text "📞" ]
                    , h3 [ class "text-xl font-semibold text-gray-900 mb-2" ]
                        [ text "Call Us" ]
                    , p [ class "text-gray-600 mb-4" ]
                        [ text "Prefer to talk? Give us a call!" ]
                    , a [ href "tel:7608921716", class "text-green-600 font-semibold text-lg" ]
                        [ text "(760) 892-1716" ]
                    ]
                , div [ class "bg-white rounded-xl shadow-lg p-6 text-center" ]
                    [ div [ class "text-4xl mb-4" ] [ text "✉️" ]
                    , h3 [ class "text-xl font-semibold text-gray-900 mb-2" ]
                        [ text "Email Us" ]
                    , p [ class "text-gray-600 mb-4" ]
                        [ text "Send us a message anytime" ]
                    , a [ href "mailto:elite.bins@gmail.com", class "text-green-600 font-semibold" ]
                        [ text "elite.bins@gmail.com" ]
                    ]
                ]
            ]
        ]


viewFormField : String -> String -> String -> String -> Maybe String -> Html Msg
viewFormField fieldName labelText placeholderText value error =
    div [ class "space-y-2" ]
        [ label [ for fieldName, class "block text-sm font-medium text-gray-700" ]
            [ text labelText ]
        , input
            [ type_ (if fieldName == "email" then "email" else if fieldName == "phone" then "tel" else "text")
            , id fieldName
            , name fieldName
            , placeholder placeholderText
            , value value
            , onInput (UpdateContactForm fieldName)
            , class ("w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-colors " ++ (case error of
                Just _ -> "border-red-500"
                Nothing -> "border-gray-300"
              ))
            ]
            []
        , case error of
            Just errorMsg ->
                div [ class "text-red-600 text-sm" ] [ text errorMsg ]

            Nothing ->
                text ""
        ]


viewTextareaField : String -> String -> String -> String -> Maybe String -> Html Msg
viewTextareaField fieldName labelText placeholderText value error =
    div [ class "space-y-2" ]
        [ label [ for fieldName, class "block text-sm font-medium text-gray-700" ]
            [ text labelText ]
        , textarea
            [ id fieldName
            , name fieldName
            , placeholder placeholderText
            , value value
            , onInput (UpdateContactForm fieldName)
            , rows 4
            , class ("w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-colors resize-none " ++ (case error of
                Just _ -> "border-red-500"
                Nothing -> "border-gray-300"
              ))
            ]
            []
        , case error of
            Just errorMsg ->
                div [ class "text-red-600 text-sm" ] [ text errorMsg ]

            Nothing ->
                text ""
        ]


viewFooter : Html Msg
viewFooter =
    footer [ class "bg-gray-900 text-white py-12" ]
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "grid grid-cols-1 md:grid-cols-3 gap-8 mb-8" ]
                [ div []
                    [ h3 [ class "text-2xl font-bold mb-4" ]
                        [ text "🗑️ EliteBins" ]
                    , p [ class "text-gray-300 mb-4" ]
                        [ text "Making life easier, one bin at a time. Serving North County San Diego with reliable, convenient waste management services." ]
                    , p [ class "text-gray-400 text-sm" ]
                        [ text "Licensed & Insured" ]
                    ]
                , div []
                    [ h4 [ class "font-semibold mb-4" ] [ text "Quick Links" ]
                    , ul [ class "space-y-2" ]
                        [ li []
                            [ button [ class "text-gray-300 hover:text-white transition-colors", onClick (SetActiveSection "home") ]
                                [ text "Home" ]
                            ]
                        , li []
                            [ button [ class "text-gray-300 hover:text-white transition-colors", onClick (SetActiveSection "about") ]
                                [ text "About" ]
                            ]
                        , li []
                            [ button [ class "text-gray-300 hover:text-white transition-colors", onClick (SetActiveSection "contact") ]
                                [ text "Get Started" ]
                            ]
                        ]
                    ]
                , div []
                    [ h4 [ class "font-semibold mb-4" ] [ text "Contact Info" ]
                    , ul [ class "space-y-2" ]
                        [ li [ class "flex items-center" ]
                            [ span [ class "mr-2" ] [ text "📞" ]
                            , a [ href "tel:7608921716", class "text-gray-300 hover:text-white transition-colors" ]
                                [ text "(760) 892-1716" ]
                            ]
                        , li [ class "flex items-center" ]
                            [ span [ class "mr-2" ] [ text "✉️" ]
                            , a [ href "mailto:elite.bins@gmail.com", class "text-gray-300 hover:text-white transition-colors" ]
                                [ text "elite.bins@gmail.com" ]
                            ]
                        , li [ class "flex items-center" ]
                            [ span [ class "mr-2" ] [ text "📍" ]
                            , span [ class "text-gray-300" ]
                                [ text "North County San Diego" ]
                            ]
                        ]
                    ]
                ]
            , div [ class "border-t border-gray-800 pt-8 text-center" ]
                [ p [ class "text-gray-400" ]
                    [ text "© 2024 EliteBins. All rights reserved. | One less thing to worry about." ]
                ]
            ]
        ]