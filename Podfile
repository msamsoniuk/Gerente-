platform :ios, "9.0"
inhibit_all_warnings!
use_frameworks!

target "Gerente" do
  #  pod 'Lock', '~> 2.2'
  # pod 'Auth0', '~> 1.5'
  # pod 'AES256CBC'
 pod 'SQLite.swift', '~> 0.11.6'
 pod 'Zip', '~> 1.1'
  pod 'PDFGenerator', '~> 3.1'
end

post_install do |installer|
    # List of Pods to use as Swift 3.2
    myTargets = ['Lock']

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
