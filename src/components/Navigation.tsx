import { Button } from "primereact/button";
import { Menubar } from "primereact/menubar";
import { useState } from "react";
import logo from "../images/logo.png";

const Navigation = () => {
  const [activeItem, setActiveItem] = useState("home");

  const items = [
    {
      label: "Home",
      icon: "pi pi-home",
      command: () => setActiveItem("home"),
      className: activeItem === "home" ? "p-menuitem-active" : "",
    },
    {
      label: "About Us",
      icon: "pi pi-wrench",
      command: () => setActiveItem("aboutUs"),
      className: activeItem === "aboutUs" ? "p-menuitem-active" : "",
    },
  ];

  const start = (
    <div className="flex items-center">
      <img src={logo} alt="Algar Logo" className="h-14 w-50 mr-2 shadow" />
      {/* <i className="text-2xl text-blue-600 mr-2"></i>
      <span className="text-xl font-bold text-gray-900">
        Algar - General Contracting
      </span> */}
    </div>
  );

  const end = (
    <div className="flex items-center space-x-6">
      <Button
        label="Contact"
        icon="pi pi-envelope"
        className="p-button-rounded p-2"
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
