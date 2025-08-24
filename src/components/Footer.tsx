import { Button } from "primereact/button";
import { Divider } from "primereact/divider";

const Footer = () => {
  return (
    <footer className="bg-gray-900 text-white py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
          <div className="col-span-1 md:col-span-2">
            <div className="flex items-center mb-4">
              <i className="pi pi-at text-2xl text-blue-400 mr-2"></i>
              <h3 className="text-2xl font-bold">Follow us on social media!</h3>
            </div>
            <div className="flex space-x-2">
              <Button
                icon="pi pi-facebook"
                className="p-button-rounded p-button-text p-button-sm"
                tooltip="Facebook"
              />
              <Button
                icon="pi pi-twitter"
                className="p-button-rounded p-button-text p-button-sm"
                tooltip="Twitter"
              />
              <Button
                icon="pi pi-instagram"
                className="p-button-rounded p-button-text p-button-sm"
                tooltip="Instagram"
              />
            </div>
          </div>

          <div>
            <h4 className="font-semibold mb-4">Quick Links</h4>
            <ul className="space-y-4">
              <li>
                <Button
                  label="Home"
                  className="p-button-text p-button-sm text-left"
                />
              </li>
              <li>
                <Button
                  label="About Us"
                  className="p-button-text p-button-sm text-left"
                />
              </li>
            </ul>
          </div>
        </div>

        <Divider className="border-gray-800" />

        <div className="flex flex-col md:flex-row justify-between items-center pt-8">
          <p className="text-gray-400 mb-4 md:mb-0">
            © 2024 Elite Bins. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
