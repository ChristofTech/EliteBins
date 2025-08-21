import React, { useState } from 'react';
import { Card } from 'primereact/card';
import { InputText } from 'primereact/inputtext';
import { InputTextarea } from 'primereact/inputtextarea';
import { Button } from 'primereact/button';
import { Message } from 'primereact/message';
import { Toast } from 'primereact/toast';
import { useRef } from 'react';

const Contact = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: ''
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [loading, setLoading] = useState(false);
  const toast = useRef<Toast>(null);

  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.name.trim()) {
      newErrors.name = 'Name is required';
    }

    if (!formData.email.trim()) {
      newErrors.email = 'Email is required';
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = 'Please enter a valid email';
    }

    if (!formData.message.trim()) {
      newErrors.message = 'Message is required';
    } else if (formData.message.trim().length < 10) {
      newErrors.message = 'Message must be at least 10 characters';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (validateForm()) {
      setLoading(true);
      
      // Simulate API call
      setTimeout(() => {
        setLoading(false);
        toast.current?.show({
          severity: 'success',
          summary: 'Success',
          detail: 'Your message has been sent successfully!',
          life: 3000
        });
        setFormData({ name: '', email: '', message: '' });
      }, 2000);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  return (
    <section className="py-24 bg-gradient-to-br from-blue-50 to-indigo-100">
      <Toast ref={toast} />
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Get In Touch
          </h2>
          <p className="text-xl text-gray-600">
            Have a question or want to work together? We'd love to hear from you.
          </p>
        </div>
        
        <Card className="shadow-xl">
          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="p-field">
                <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
                  Your Name
                </label>
                <InputText
                  id="name"
                  name="name"
                  value={formData.name}
                  onChange={handleChange}
                  placeholder="John Doe"
                  className={`w-full ${errors.name ? 'p-invalid' : ''}`}
                />
                {errors.name && <Message severity="error" text={errors.name} className="mt-1" />}
              </div>
              
              <div className="p-field">
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                  Email Address
                </label>
                <InputText
                  id="email"
                  name="email"
                  type="email"
                  value={formData.email}
                  onChange={handleChange}
                  placeholder="john@example.com"
                  className={`w-full ${errors.email ? 'p-invalid' : ''}`}
                />
                {errors.email && <Message severity="error" text={errors.email} className="mt-1" />}
              </div>
            </div>
            
            <div className="p-field">
              <label htmlFor="message" className="block text-sm font-medium text-gray-700 mb-2">
                Your Message
              </label>
              <InputTextarea
                id="message"
                name="message"
                rows={6}
                value={formData.message}
                onChange={handleChange}
                placeholder="Tell us about your project or ask us anything..."
                className={`w-full ${errors.message ? 'p-invalid' : ''}`}
              />
              {errors.message && <Message severity="error" text={errors.message} className="mt-1" />}
            </div>
            
            <Button
              type="submit"
              label="Send Message"
              icon="pi pi-send"
              loading={loading}
              className="w-full p-button-lg"
            />
          </form>
        </Card>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mt-12">
          <Card className="text-center bg-white/80 backdrop-blur-sm border border-white/20">
            <div className="space-y-4">
              <i className="pi pi-envelope text-4xl text-blue-600"></i>
              <h3 className="text-xl font-semibold text-gray-900">Email Us</h3>
              <p className="text-gray-600">hello@yourcompany.com</p>
            </div>
          </Card>
          
          <Card className="text-center bg-white/80 backdrop-blur-sm border border-white/20">
            <div className="space-y-4">
              <i className="pi pi-comments text-4xl text-emerald-600"></i>
              <h3 className="text-xl font-semibold text-gray-900">Live Chat</h3>
              <p className="text-gray-600">Available Mon-Fri, 9AM-6PM</p>
            </div>
          </Card>
        </div>
      </div>
    </section>
  );
};

export default Contact;