# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BearBurp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BearBurp
	pod 'HDAugmentedReality', '~> 3.0'
  pod 'GoogleMaps', '7.2.0'

  target 'BearBurpTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BearBurpUITests' do
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

end

