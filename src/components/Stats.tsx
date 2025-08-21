import React, { useState, useEffect } from 'react';
import { Card } from 'primereact/card';
import { ProgressBar } from 'primereact/progressbar';
import { Knob } from 'primereact/knob';

interface StatItem {
  icon: string;
  label: string;
  value: number;
  suffix: string;
  color: string;
  type: 'counter' | 'progress' | 'knob';
  max?: number;
}

const stats: StatItem[] = [
  {
    icon: 'pi pi-users',
    label: 'Active Users',
    value: 50000,
    suffix: '+',
    color: 'text-blue-600',
    type: 'counter'
  },
  {
    icon: 'pi pi-chart-line',
    label: 'Growth Rate',
    value: 85,
    suffix: '%',
    color: 'text-emerald-600',
    type: 'progress',
    max: 100
  },
  {
    icon: 'pi pi-star',
    label: 'User Rating',
    value: 4.9,
    suffix: '/5',
    color: 'text-yellow-500',
    type: 'knob',
    max: 5
  },
  {
    icon: 'pi pi-download',
    label: 'Downloads',
    value: 250000,
    suffix: '+',
    color: 'text-purple-600',
    type: 'counter'
  }
];

const AnimatedCounter = ({ target, suffix }: { target: number; suffix: string }) => {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const duration = 2000;
    const steps = 60;
    const increment = target / steps;
    let current = 0;

    const timer = setInterval(() => {
      current += increment;
      if (current >= target) {
        setCount(target);
        clearInterval(timer);
      } else {
        setCount(Math.floor(current));
      }
    }, duration / steps);

    return () => clearInterval(timer);
  }, [target]);

  const formatNumber = (num: number) => {
    if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M';
    if (num >= 1000) return (num / 1000).toFixed(1) + 'K';
    return num.toString();
  };

  return (
    <span className="text-3xl md:text-4xl font-bold">
      {target === 4.9 ? count.toFixed(1) : formatNumber(count)}
      {suffix}
    </span>
  );
};

const Stats = () => {
  return (
    <section className="py-24 bg-gradient-to-r from-gray-50 to-blue-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Trusted by Thousands
          </h2>
          <p className="text-xl text-gray-600">
            Join the growing community of developers building with our platform
          </p>
        </div>
        
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
          {stats.map((stat, index) => {
            const renderStatContent = () => {
              switch (stat.type) {
                case 'progress':
                  return (
                    <div className="space-y-4">
                      <div className={`${stat.color} text-2xl font-bold`}>
                        {stat.value}{stat.suffix}
                      </div>
                      <ProgressBar 
                        value={stat.value} 
                        className="h-2"
                        color={stat.color.includes('blue') ? '#3B82F6' : 
                              stat.color.includes('emerald') ? '#10B981' : 
                              stat.color.includes('yellow') ? '#F59E0B' : '#8B5CF6'}
                      />
                    </div>
                  );
                case 'knob':
                  return (
                    <div className="flex flex-col items-center space-y-4">
                      <Knob 
                        value={stat.value} 
                        max={stat.max} 
                        size={80}
                        valueColor={stat.color.includes('yellow') ? '#F59E0B' : '#3B82F6'}
                        rangeColor="#E5E7EB"
                      />
                      <div className={`${stat.color} text-xl font-bold`}>
                        {stat.value}{stat.suffix}
                      </div>
                    </div>
                  );
                default:
                  return (
                    <div className={`${stat.color}`}>
                      <AnimatedCounter target={stat.value} suffix={stat.suffix} />
                    </div>
                  );
              }
            };

            const header = (
              <div className="flex justify-center p-4">
                <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center">
                  <i className={`${stat.icon} text-2xl ${stat.color}`}></i>
                </div>
              </div>
            );

            return (
              <Card
                key={index}
                header={header}
                className="text-center hover:shadow-lg transition-all duration-300 border border-white/20 bg-white/80 backdrop-blur-sm"
              >
                <div className="space-y-4">
                  {renderStatContent()}
                  <p className="text-gray-600 font-medium">
                    {stat.label}
                  </p>
                </div>
              </Card>
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default Stats;