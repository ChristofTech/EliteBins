export const Hero = () => {
  return (
    <section className="min-h-[85vh] flex items-center justify-center bg-gradient-to-r from-green-600 via-lime-600 to-emerald-600">
      {/* Background Pattern */}
      <div className="inset-0 opacity-10">
        <div className="inset-0 bg-[radial-gradient(circle_at_25%_25%,_theme(colors.emerald.500)_0%,_transparent_50%)]"></div>
        <div className="inset-0 bg-[radial-gradient(circle_at_75%_75%,_theme(colors.green.500)_0%,_transparent_50%)]"></div>
      </div>

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div className="animate-fade-in-up">
          <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold text-gray-900 mb-6 leading-tight text-neutral-50">
            Elite Bins
          </h1>
          <h2 className="text-2xl md:text-4xl lg:text-5xl font-semibold text-gray-500 mb-4 text-lime-300">
            "One less thing to worry about"
          </h2>
        </div>

        {/* Floating Elements */}
        <div className="absolute top-1/4 left-1/4 w-20 h-20 bg-blue-lime/20 rounded-full blur-xl animate-pulse"></div>
        <div className="absolute bottom-1/4 right-1/4 w-96 h-64 bg-teal-400/20 rounded-full blur-xl animate-pulse delay-1000"></div>
        <div className="absolute top-1/2 right-1/3 w-16 h-16 bg-emerald-400/20 rounded-full blur-xl animate-pulse delay-2000"></div>
      </div>
    </section>
  );
};
