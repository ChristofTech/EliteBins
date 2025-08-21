import React from 'react';
import Navigation from './components/Navigation';
import Hero from './components/Hero';
import Features from './components/Features';
import Stats from './components/Stats';
import Testimonials from './components/Testimonials';
import Contact from './components/Contact';
import Footer from './components/Footer';

// PrimeReact CSS
import 'primereact/resources/themes/lara-light-blue/theme.css';
import 'primereact/resources/primereact.min.css';
import 'primeicons/primeicons.css';

function App() {
  console.log("App component rendered");
  return (
    <div className="min-h-screen">
      <Navigation />
      <Hero />
      <Features />
      <Stats />
      <Testimonials />
      <Contact />
      <Footer />
    </div>
  );
}

export default App;