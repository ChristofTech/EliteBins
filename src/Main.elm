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
    , message : String
    }


type alias FormErrors =
    { name : Maybe String
    , email : Maybe String
    , message : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { activeSection = "home"
      , mobileMenuOpen = False
      , contactForm = { name = "", email = "", message = "" }
      , formErrors = { name = Nothing, email = Nothing, message = Nothing }
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
            ( { model | activeSection = section }, Cmd.none )

        ToggleMobileMenu ->
            ( { model | mobileMenuOpen = not model.mobileMenuOpen }, Cmd.none )

        UpdateContactForm field value ->
            let
                updatedForm =
                    case field of
                        "name" ->
                            { name = value, email = model.contactForm.email, message = model.contactForm.message }

                        "email" ->
                            { name = model.contactForm.name, email = value, message = model.contactForm.message }

                        "message" ->
                            { name = model.contactForm.name, email = model.contactForm.email, message = value }

                        _ ->
                            model.contactForm

                clearedErrors =
                    case field of
                        "name" ->
                            { name = Nothing, email = model.formErrors.email, message = model.formErrors.message }

                        "email" ->
                            { name = model.formErrors.name, email = Nothing, message = model.formErrors.message }

                        "message" ->
                            { name = model.formErrors.name, email = model.formErrors.email, message = Nothing }

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
                ( { model | isSubmitting = True, formErrors = { name = Nothing, email = Nothing, message = Nothing } }
                , submitForm model.contactForm
                )

        ContactFormSubmitted result ->
            case result of
                Ok _ ->
                    ( { model
                        | isSubmitting = False
                        , submitMessage = Just "Your message has been sent successfully!"
                        , contactForm = { name = "", email = "", message = "" }
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                        | isSubmitting = False
                        , submitMessage = Just "There was an error sending your message. Please try again."
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
    , message =
        if String.trim form.message == "" then
            Just "Message is required"

        else if String.length (String.trim form.message) < 10 then
            Just "Message must be at least 10 characters"

        else
            Nothing
    }


hasErrors : FormErrors -> Bool
hasErrors errors =
    errors.name /= Nothing || errors.email /= Nothing || errors.message /= Nothing


isValidEmail : String -> Bool
isValidEmail email =
    String.contains "@" email && String.contains "." email


-- HTTP


submitForm : ContactForm -> Cmd Msg
submitForm form =
    -- Simulate form submission
    Http.get
        { url = "https://httpbin.org/delay/2"
        , expect = Http.expectString ContactFormSubmitted
        }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- DATA


type alias Testimonial =
    { name : String
    , residence : String
    , content : String
    , rating : Int
    , avatar : String
    }


testimonials : List Testimonial
testimonials =
    [ { name = "Sarah Johnson"
      , residence = "Oceanside, CA"
      , content = "Eli did an amazing job with my kitchen remodel!"
      , rating = 5
      , avatar = "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=400"
      }
    , { name = "Michael Chen"
      , residence = "Vista, CA"
      , content = "Lorem ipsum dolor"
      , rating = 5
      , avatar = "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400"
      }
    , { name = "Emily Rodriguez"
      , residence = "Escondido, CA"
      , content = "Fantastic service and attention to detail. Highly recommend!"
      , rating = 5
      , avatar = "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400"
      }
    ]


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , viewHero
        , viewTestimonials model
        , viewContact model
        , viewFooter
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    header [ class "fixed top-0 left-0 right-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-200" ]
        [ -- Desktop Navigation
          div [ class "hidden md:flex items-center justify-between px-8 py-4" ]
            [ div [ class "flex items-center" ]
                [ img
                    [ src "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='60' viewBox='0 0 100 60'%3E%3Crect width='100' height='60' fill='%234ade80'/%3E%3Ctext x='50' y='35' font-family='Arial' font-size='14' font-weight='bold' text-anchor='middle' fill='white'%3EElite Bins%3C/text%3E%3C/svg%3E"
                    , alt "Elite Bins Logo"
                    , class "w-32 h-20 mr-4 shadow rounded"
                    ]
                    []
                ]
            , nav [ class "flex space-x-8" ]
                [ button
                    [ class ("px-4 py-2 rounded-lg transition-colors " ++ (if model.activeSection == "home" then "bg-blue-100 text-blue-600" else "text-gray-600 hover:text-blue-600"))
                    , onClick (SetActiveSection "home")
                    ]
                    [ text "🏠 Home" ]
                , button
                    [ class ("px-4 py-2 rounded-lg transition-colors " ++ (if model.activeSection == "aboutUs" then "bg-blue-100 text-blue-600" else "text-gray-600 hover:text-blue-600"))
                    , onClick (SetActiveSection "aboutUs")
                    ]
                    [ text "🔧 About Us" ]
                ]
            , div [ class "flex flex-col items-end space-y-2" ]
                [ button
                    [ class "px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                    , onClick (SetActiveSection "contact")
                    ]
                    [ text "📞 (760) 892-1716" ]
                , div [ class "text-sm text-gray-600" ]
                    [ text "✉️ elite.bins@gmail.com" ]
                ]
            ]
        , -- Mobile Navigation
          div [ class "md:hidden" ]
            [ div [ class "flex items-center justify-between px-4 py-2" ]
                [ img
                    [ src "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='48' viewBox='0 0 80 48'%3E%3Crect width='80' height='48' fill='%234ade80'/%3E%3Ctext x='40' y='28' font-family='Arial' font-size='10' font-weight='bold' text-anchor='middle' fill='white'%3EElite Bins%3C/text%3E%3C/svg%3E"
                    , alt "Elite Bins Logo"
                    , class "w-24 h-14 shadow rounded"
                    ]
                    []
                , button
                    [ class "p-2 rounded-lg bg-gray-100 hover:bg-gray-200 transition-colors"
                    , onClick ToggleMobileMenu
                    ]
                    [ text (if model.mobileMenuOpen then "✕" else "☰") ]
                ]
            , if model.mobileMenuOpen then
                div [ class "bg-white border-t border-gray-200 px-4 py-2 space-y-2" ]
                    [ button
                        [ class "block w-full text-left px-4 py-2 rounded-lg text-gray-600 hover:bg-gray-100"
                        , onClick (SetActiveSection "home")
                        ]
                        [ text "🏠 Home" ]
                    , button
                        [ class "block w-full text-left px-4 py-2 rounded-lg text-gray-600 hover:bg-gray-100"
                        , onClick (SetActiveSection "aboutUs")
                        ]
                        [ text "🔧 About Us" ]
                    , button
                        [ class "block w-full text-left px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700"
                        , onClick (SetActiveSection "contact")
                        ]
                        [ text "📞 (760) 892-1716" ]
                    , div [ class "px-4 py-2 text-sm text-gray-600" ]
                        [ text "✉️ elite.bins@gmail.com" ]
                    ]

              else
                text ""
            ]
        ]


viewHero : Html Msg
viewHero =
    section [ class "min-h-screen flex items-center justify-center bg-gradient-to-r from-green-600 via-lime-600 to-emerald-600 relative overflow-hidden" ]
        [ div [ class "relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center mt-20" ]
            [ div [ class "animate-fade-in-up" ]
                [ h1 [ class "text-4xl md:text-6xl lg:text-7xl font-bold text-white mb-6 leading-tight" ]
                    [ text "ELITE BINS" ]
                , h2 [ class "text-2xl md:text-4xl lg:text-5xl font-semibold text-lime-300 mb-4" ]
                    [ text "\"One less thing to worry about\"" ]
                , p [ class "text-lg md:text-xl text-gray-300 max-w-3xl mx-auto mb-8" ]
                    [ text "We take your bins out and bring them back in, so you don't have to. Reliable, convenient, and hassle-free waste management services for your home!" ]
                ]
            ]
        , -- Floating Elements
          div [ class "absolute top-1/4 left-1/4 w-20 h-20 bg-blue-400/20 rounded-full blur-xl animate-pulse" ] []
        , div [ class "absolute bottom-1/4 right-1/4 w-96 h-64 bg-teal-400/20 rounded-full blur-xl animate-pulse" ] []
        , div [ class "absolute top-1/2 right-1/3 w-16 h-16 bg-emerald-400/20 rounded-full blur-xl animate-pulse" ] []
        ]


viewTestimonials : Model -> Html Msg
viewTestimonials model =
    section [ class "py-24 bg-gray-900 text-white overflow-hidden" ]
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "text-center mb-16" ]
                [ h2 [ class "text-3xl md:text-4xl font-bold mb-4" ]
                    [ text "Meet the team!" ]
                ]
            , div [ class "relative" ]
                [ case List.drop model.currentTestimonial testimonials |> List.head of
                    Just testimonial ->
                        viewTestimonialCard testimonial

                    Nothing ->
                        text ""
                , div [ class "flex justify-center items-center space-x-4 mt-8" ]
                    [ button
                        [ class "p-2 rounded-full bg-white/20 hover:bg-white/30 transition-colors"
                        , onClick PrevTestimonial
                        ]
                        [ text "‹" ]
                    , div [ class "flex space-x-2" ]
                        (List.indexedMap (viewTestimonialIndicator model.currentTestimonial) testimonials)
                    , button
                        [ class "p-2 rounded-full bg-white/20 hover:bg-white/30 transition-colors"
                        , onClick NextTestimonial
                        ]
                        [ text "›" ]
                    ]
                ]
            ]
        ]


viewTestimonialCard : Testimonial -> Html Msg
viewTestimonialCard testimonial =
    div [ class "max-w-2xl mx-auto" ]
        [ div [ class "bg-white/10 backdrop-blur-sm border border-white/20 rounded-xl p-8 text-center" ]
            [ div [ class "flex justify-center mb-6" ]
                [ img
                    [ src testimonial.avatar
                    , alt testimonial.name
                    , class "w-20 h-20 rounded-full border-2 border-white/20"
                    ]
                    []
                ]
            , div [ class "space-y-4 mb-6" ]
                [ div [ class "text-3xl text-blue-400" ] [ text """ ]
                , blockquote [ class "text-lg leading-relaxed text-gray-200 italic" ]
                    [ text testimonial.content ]
                ]
            , div [ class "text-center space-y-2" ]
                [ div [ class "flex justify-center space-x-1 mb-2" ]
                    (List.repeat testimonial.rating (span [ class "text-yellow-400" ] [ text "★" ]))
                , h4 [ class "font-semibold text-white" ] [ text testimonial.name ]
                , p [ class "text-gray-300 text-sm" ] [ text testimonial.residence ]
                ]
            ]
        ]


viewTestimonialIndicator : Int -> Int -> Testimonial -> Html Msg
viewTestimonialIndicator currentIndex index testimonial =
    button
        [ class ("w-3 h-3 rounded-full transition-colors " ++ (if currentIndex == index then "bg-blue-400" else "bg-white/30"))
        , onClick (SetActiveSection "testimonial")
        ]
        []


viewContact : Model -> Html Msg
viewContact model =
    section [ class "py-24 bg-gradient-to-br from-lime-50 to-green-100" ]
        [ div [ class "max-w-4xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ div [ class "text-center mb-16" ]
                [ h2 [ class "text-3xl md:text-4xl font-bold text-gray-900 mb-4" ]
                    [ text "Get In Touch" ]
                , p [ class "text-xl text-gray-600" ]
                    [ text "Have a question or want to work together? We'd love to hear from you." ]
                ]
            , div [ class "bg-white rounded-xl shadow-xl p-8" ]
                [ Html.form [ onSubmit SubmitContactForm, class "space-y-6" ]
                    [ div [ class "grid grid-cols-1 md:grid-cols-2 gap-6" ]
                        [ viewFormField "name" "Your Name" "John Doe" model.contactForm.name model.formErrors.name
                        , viewFormField "email" "Email Address" "john@example.com" model.contactForm.email model.formErrors.email
                        ]
                    , viewTextareaField "message" "Your Message" "Tell us about your project or ask us anything..." model.contactForm.message model.formErrors.message
                    , div [ class "flex justify-center" ]
                        [ button
                            [ type_ "submit"
                            , class ("px-8 py-3 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 transition-colors " ++ (if model.isSubmitting then "opacity-50 cursor-not-allowed" else ""))
                            , disabled model.isSubmitting
                            ]
                            [ text (if model.isSubmitting then "Sending..." else "Send Message 📧") ]
                        ]
                    , case model.submitMessage of
                        Just message ->
                            div [ class "text-center p-4 bg-green-100 text-green-800 rounded-lg" ]
                                [ text message
                                , button
                                    [ class "ml-4 text-green-600 hover:text-green-800"
                                    , onClick ClearSubmitMessage
                                    ]
                                    [ text "✕" ]
                                ]

                        Nothing ->
                            text ""
                    ]
                ]
            , div [ class "mt-12" ]
                [ div [ class "bg-white/80 backdrop-blur-sm border border-white/20 rounded-xl p-8 text-center" ]
                    [ div [ class "space-y-4" ]
                        [ div [ class "text-4xl text-blue-600" ] [ text "✉️" ]
                        , h3 [ class "text-xl font-semibold text-gray-900" ] [ text "Email Us" ]
                        , p [ class "text-gray-600" ] [ text "elite.bins@gmail.com" ]
                        ]
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
            [ type_ (if fieldName == "email" then "email" else "text")
            , id fieldName
            , name fieldName
            , placeholder placeholderText
            , value value
            , onInput (UpdateContactForm fieldName)
            , class ("w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors " ++ (case error of
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
            , rows 6
            , class ("w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors resize-none " ++ (case error of
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
            [ div [ class "grid grid-cols-1 md:grid-cols-4 gap-8 mb-8" ]
                [ div [ class "col-span-1 md:col-span-2" ]
                    [ div [ class "flex items-center mb-4" ]
                        [ div [ class "text-2xl text-blue-400 mr-2" ] [ text "@" ]
                        , h3 [ class "text-2xl font-bold" ] [ text "Follow us on social media!" ]
                        ]
                    , div [ class "flex space-x-4" ]
                        [ button [ class "p-2 rounded-full bg-blue-600 hover:bg-blue-700 transition-colors" ]
                            [ text "f" ]
                        , button [ class "p-2 rounded-full bg-blue-400 hover:bg-blue-500 transition-colors" ]
                            [ text "t" ]
                        , button [ class "p-2 rounded-full bg-pink-600 hover:bg-pink-700 transition-colors" ]
                            [ text "i" ]
                        ]
                    ]
                , div []
                    [ h4 [ class "font-semibold mb-4" ] [ text "Quick Links" ]
                    , ul [ class "space-y-2" ]
                        [ li []
                            [ button [ class "text-gray-300 hover:text-white transition-colors" ]
                                [ text "Home" ]
                            ]
                        , li []
                            [ button [ class "text-gray-300 hover:text-white transition-colors" ]
                                [ text "About Us" ]
                            ]
                        ]
                    ]
                ]
            , div [ class "border-t border-gray-800 pt-8" ]
                [ div [ class "flex flex-col md:flex-row justify-between items-center" ]
                    [ p [ class "text-gray-400 mb-4 md:mb-0" ]
                        [ text "© 2024 Elite Bins. All rights reserved." ]
                    ]
                ]
            ]
        ]