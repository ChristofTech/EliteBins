import { Button } from "primereact/button";
import { Menubar } from "primereact/menubar";
import { useState } from "react";
import logo_bg from "../images/logo_bg.png";

const Header = () => {
  const [activeItem, setActiveItem] = useState("home");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

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
      <img
        src={logo_bg}
        alt="Elite Bins Logo"
        className="max-w-[40vw] w-[10rem] max-h-[20vh] h-[6rem] mr-2 shadow"
      />
    </div>
  );

  const end = (
    <div className="hidden md:flex flex-col items-end space-x-6">
      <Button
        label="(123) 456-7890"
        icon="pi pi-phone"
        className="p-button-rounded p-2"
      />
      <Button
        label="elite.bins@gmail.com"
        icon="pi pi-envelope"
        className="p-button-rounded p-2"
      />
    </div>
  );

  const desktop = (
    <div className="hidden md:block">
      <Menubar
        model={items}
        start={start}
        end={end}
        className="border-none bg-transparent !pt-100"
      />
    </div>
  );

  const mobile = (
    <>
      <div className="flex md:hidden items-center justify-between px-4 py-2">
        {start}
        <Button
          icon={mobileMenuOpen ? "pi pi-times" : "pi pi-bars"}
          className="p-button-rounded p-2"
          onClick={() => setMobileMenuOpen((open) => !open)}
        />
      </div>
      {mobileMenuOpen && (
        <div className="md:hidden bg-white border-t border-gray-200 px-4 py-2">
          {items.map((item) => (
            <Button
              key={item.label}
              label={item.label}
              icon={item.icon}
              className={`w-full mb-2 ${item.className}`}
              onClick={item.command}
            />
          ))}
          <Button
            label="(123) 456-7890"
            icon="pi pi-phone"
            className="w-full mb-2"
          />
          <Button
            label="elite.bins@gmail.com"
            icon="pi pi-envelope"
            className="w-full"
          />
        </div>
      )}
    </>
  );

  return (
    <div className="fixed top-0 left-0 right-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-200">
      {desktop}
      {mobile}
    </div>
  );
};

export default Header;
