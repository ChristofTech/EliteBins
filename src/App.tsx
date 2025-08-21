import Contact from "./components/Contact";
import Footer from "./components/Footer";
import Hero from "./components/Hero";
import Navigation from "./components/Navigation";
import Testimonials from "./components/Testimonials";

// PrimeReact CSS
import "primeicons/primeicons.css";
import "primereact/resources/primereact.min.css";
import "primereact/resources/themes/lara-light-blue/theme.css";

function App() {
  return (
    <div className="min-h-screen">
      <Navigation />
      <Hero />
      <Testimonials />
      <Contact />
      <Footer />
    </div>
  );
}

export default App;
