import { Avatar } from "primereact/avatar";
import { Card } from "primereact/card";
import { Carousel } from "primereact/carousel";
import { Rating } from "primereact/rating";

const testimonials = [
  {
    name: "Sarah Johnson",
    residence: "Oceanside, CA",
    content: "Eli did an amazing job with my kitchen remodel!",
    rating: 5,
    avatar:
      "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=400",
  },
  {
    name: "Michael Chen",
    residence: "Vista, CA",
    content: "Lorem ipsum dolor",
    rating: 5,
    avatar:
      "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
  },
  {
    name: "Emily Rodriguez",
    residence: "Escondido, CA",
    content: "Fantastic service and attention to detail. Highly recommend!",
    rating: 5,
    avatar:
      "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
  },
];

const Testimonials = () => {
  const testimonialTemplate = (testimonial: (typeof testimonials)[0]) => {
    const header = (
      <div className="flex justify-center p-4">
        <Avatar
          image={testimonial.avatar}
          size="xlarge"
          shape="circle"
          className="border-2 border-white/20"
        />
      </div>
    );

    const footer = (
      <div className="text-center space-y-2">
        <Rating
          value={testimonial.rating}
          readOnly
          cancel={false}
          className="flex justify-center"
        />
        <div>
          <h4 className="font-semibold text-white">{testimonial.name}</h4>
          <p className="text-gray-300 text-sm">{testimonial.residence}</p>
        </div>
      </div>
    );

    return (
      <div className="p-4">
        <Card
          header={header}
          footer={footer}
          className="bg-white/10 backdrop-blur-sm border border-white/20 text-center"
        >
          <div className="space-y-4">
            <i className="pi pi-quote-left text-3xl text-blue-400"></i>
            <blockquote className="text-lg leading-relaxed text-gray-200 italic">
              "{testimonial.content}"
            </blockquote>
          </div>
        </Card>
      </div>
    );
  };

  return (
    <section className="py-24 bg-gray-900 text-white overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            What homeowners had to say about Elite Bins!
          </h2>
        </div>

        <Carousel
          value={testimonials}
          itemTemplate={testimonialTemplate}
          numVisible={1}
          numScroll={1}
          autoplayInterval={5000}
          circular
          showIndicators
          showNavigators
          className="custom-carousel"
        />
      </div>
    </section>
  );
};

export default Testimonials;
