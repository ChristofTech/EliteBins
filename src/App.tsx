import Contact from "./components/Contact";
import Footer from "./components/Footer";
import Header from "./components/Header";
import { Hero } from "./components/Hero";
import Testimonials from "./components/Testimonials";

// PrimeReact CSS
import "primeicons/primeicons.css";
import "primereact/resources/primereact.min.css";
import "primereact/resources/themes/lara-light-blue/theme.css";

function App() {
  return (
    <div>
      <Header />
      <Hero />
      <Testimonials />
      <Contact />
      <Footer />
    </div>
  );
}

export default App;
