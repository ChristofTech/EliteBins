import React, { useState } from 'react';
import { Menubar } from 'primereact/menubar';
import { Button } from 'primereact/button';
import { Badge } from 'primereact/badge';

const Navigation = () => {
  const [activeItem, setActiveItem] = useState('home');

  const items = [
    {
      label: 'Home',
      icon: 'pi pi-home',
      command: () => setActiveItem('home'),
      className: activeItem === 'home' ? 'p-menuitem-active' : ''
    },
    {
      label: 'Features',
      icon: 'pi pi-star',
      command: () => setActiveItem('features'),
      className: activeItem === 'features' ? 'p-menuitem-active' : ''
    },
    {
      label: 'Stats',
      icon: 'pi pi-chart-line',
      command: () => setActiveItem('stats'),
      className: activeItem === 'stats' ? 'p-menuitem-active' : ''
    },
    {
      label: 'Testimonials',
      icon: 'pi pi-comments',
      command: () => setActiveItem('testimonials'),
      className: activeItem === 'testimonials' ? 'p-menuitem-active' : ''
    },
    {
      label: 'Contact',
      icon: 'pi pi-envelope',
      command: () => setActiveItem('contact'),
      className: activeItem === 'contact' ? 'p-menuitem-active' : ''
    }
  ];

  const start = (
    <div className="flex items-center">
      <i className="pi pi-bolt text-2xl text-blue-600 mr-2"></i>
      <span className="text-xl font-bold text-gray-900">ReactApp</span>
    </div>
  );

  const end = (
    <div className="flex items-center space-x-2">
      <Button 
        icon="pi pi-bell" 
        className="p-button-text p-button-rounded" 
        badge="3" 
        badgeClassName="p-badge-danger"
      />
      <Button 
        label="Get Started" 
        icon="pi pi-arrow-right" 
        className="p-button-rounded"
      />
    </div>
  );

  return (
    <div className="fixed top-0 left-0 right-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-200">
      <Menubar 
        model={items} 
        start={start} 
        end={end}
        className="border-none bg-transparent"
      />
    </div>
  );
};

export default Navigation;