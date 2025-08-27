// PrimeReact CSS
import "primeicons/primeicons.css";
import "primereact/resources/primereact.min.css";
import "primereact/resources/themes/lara-light-blue/theme.css";

import Contact from "./components/Contact";
import Footer from "./components/Footer";
import Header from "./components/Header";
import { Hero } from "./components/Hero";
import { PhotoCarousel } from "./components/PhotoCarousel";

function App() {
  console.log("test");
  return (
    <div>
      <Header />
      <Hero />
      <PhotoCarousel />
      <Contact />
      <Footer />
    </div>
  );
}

export default App;
