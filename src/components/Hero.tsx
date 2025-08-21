import React from 'react';
import { Button } from 'primereact/button';
import { Card } from 'primereact/card';
import { Badge } from 'primereact/badge';

const Hero = () => {
  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 pt-20">
      {/* Background Pattern */}
      <div className="absolute inset-0 opacity-10">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_25%_25%,_theme(colors.blue.500)_0%,_transparent_50%)]"></div>
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_75%_75%,_theme(colors.purple.500)_0%,_transparent_50%)]"></div>
      </div>
      
      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div className="animate-fade-in-up">
          <div className="flex items-center justify-center mb-6">
            <Badge 
              value="Built with React & Vite" 
              severity="info" 
              className="bg-white/20 backdrop-blur-sm text-gray-700"
            >
              <i className="pi pi-sparkles mr-2"></i>
            </Badge>
          </div>
          
          <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold text-gray-900 mb-6 leading-tight">
            Build Amazing
            <span className="block bg-gradient-to-r from-blue-600 via-purple-600 to-emerald-600 bg-clip-text text-transparent">
              Web Experiences
            </span>
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-3xl mx-auto leading-relaxed">
            Create stunning, responsive applications with modern React patterns, 
            beautiful animations, and production-ready components powered by PrimeReact.
          </p>
          
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Button 
              label="Get Started" 
              icon="pi pi-arrow-right" 
              className="p-button-lg p-button-rounded transform hover:scale-105 transition-transform duration-300"
              iconPos="right"
            />
            
            <Button 
              label="Watch Demo" 
              icon="pi pi-play" 
              className="p-button-lg p-button-rounded p-button-outlined transform hover:scale-105 transition-transform duration-300"
            />
          </div>
        </div>
        
        {/* Floating Elements */}
        <div className="absolute top-1/4 left-1/4 w-20 h-20 bg-blue-400/20 rounded-full blur-xl animate-pulse"></div>
        <div className="absolute bottom-1/4 right-1/4 w-32 h-32 bg-purple-400/20 rounded-full blur-xl animate-pulse delay-1000"></div>
        <div className="absolute top-1/2 right-1/3 w-16 h-16 bg-emerald-400/20 rounded-full blur-xl animate-pulse delay-2000"></div>
      </div>
    </section>
  );
};

export default Hero;