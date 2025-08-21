import React from 'react';
import { Card } from 'primereact/card';
import { Button } from 'primereact/button';

const features = [
  {
    icon: 'pi pi-bolt',
    title: 'Lightning Fast',
    description: 'Built with Vite for instant hot reload and optimized production builds.',
    color: 'text-yellow-500'
  },
  {
    icon: 'pi pi-shield',
    title: 'TypeScript Ready',
    description: 'Full TypeScript support with strict type checking and IntelliSense.',
    color: 'text-blue-500'
  },
  {
    icon: 'pi pi-palette',
    title: 'Beautiful Design',
    description: 'Modern UI components with PrimeReact and smooth animations.',
    color: 'text-purple-500'
  },
  {
    icon: 'pi pi-code',
    title: 'Clean Code',
    description: 'Organized component structure following React best practices.',
    color: 'text-green-500'
  },
  {
    icon: 'pi pi-globe',
    title: 'SEO Optimized',
    description: 'Built-in performance optimizations and SEO-friendly structure.',
    color: 'text-indigo-500'
  },
  {
    icon: 'pi pi-mobile',
    title: 'Mobile First',
    description: 'Fully responsive design that works perfectly on all devices.',
    color: 'text-teal-500'
  }
];

const Features = () => {
  return (
    <section className="py-24 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Powerful Features
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Everything you need to build modern, scalable web applications with PrimeReact
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => {
            const header = (
              <div className="flex justify-center p-4">
                <div className={`w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center`}>
                  <i className={`${feature.icon} text-2xl ${feature.color}`}></i>
                </div>
              </div>
            );

            const footer = (
              <div className="flex justify-center">
                <Button 
                  label="Learn More" 
                  icon="pi pi-arrow-right" 
                  className="p-button-text p-button-sm"
                  iconPos="right"
                />
              </div>
            );

            return (
              <Card
                key={index}
                title={feature.title}
                subTitle={feature.description}
                header={header}
                footer={footer}
                className="hover:shadow-xl transition-all duration-300 hover:-translate-y-1 border border-gray-200"
              />
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default Features;