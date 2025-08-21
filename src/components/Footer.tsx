import React from 'react';
import { Button } from 'primereact/button';
import { Divider } from 'primereact/divider';

const Footer = () => {
  return (
    <footer className="bg-gray-900 text-white py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
          <div className="col-span-1 md:col-span-2">
            <div className="flex items-center mb-4">
              <i className="pi pi-bolt text-2xl text-blue-400 mr-2"></i>
              <h3 className="text-2xl font-bold">ReactApp</h3>
            </div>
            <p className="text-gray-400 mb-4 max-w-md">
              A modern React template built with Vite, TypeScript, Tailwind CSS, and PrimeReact. 
              Perfect for creating beautiful, responsive web applications.
            </p>
            <div className="flex space-x-2">
              <Button 
                icon="pi pi-github" 
                className="p-button-rounded p-button-text p-button-sm"
                tooltip="GitHub"
              />
              <Button 
                icon="pi pi-twitter" 
                className="p-button-rounded p-button-text p-button-sm"
                tooltip="Twitter"
              />
              <Button 
                icon="pi pi-linkedin" 
                className="p-button-rounded p-button-text p-button-sm"
                tooltip="LinkedIn"
              />
            </div>
          </div>
          
          <div>
            <h4 className="font-semibold mb-4">Quick Links</h4>
            <ul className="space-y-2">
              <li><Button label="Home" className="p-button-text p-button-sm text-left" /></li>
              <li><Button label="Features" className="p-button-text p-button-sm text-left" /></li>
              <li><Button label="About" className="p-button-text p-button-sm text-left" /></li>
              <li><Button label="Contact" className="p-button-text p-button-sm text-left" /></li>
            </ul>
          </div>
          
          <div>
            <h4 className="font-semibold mb-4">Resources</h4>
            <ul className="space-y-2">
              <li><Button label="Documentation" className="p-button-text p-button-sm text-left" /></li>
              <li><Button label="Tutorials" className="p-button-text p-button-sm text-left" /></li>
              <li><Button label="Support" className="p-button-text p-button-sm text-left" /></li>
              <li><Button label="FAQ" className="p-button-text p-button-sm text-left" /></li>
            </ul>
          </div>
        </div>
        
        <Divider className="border-gray-800" />
        
        <div className="flex flex-col md:flex-row justify-between items-center pt-8">
          <p className="text-gray-400 mb-4 md:mb-0">
            © 2025 ReactApp. All rights reserved.
          </p>
          <div className="flex items-center text-gray-400">
            <span>Made with</span>
            <i className="pi pi-heart-fill text-red-500 mx-1"></i>
            <span>by developers, for developers</span>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;