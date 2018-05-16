Pod::Spec.new do |s|

  s.name         = "CPProgressDotsView"
  s.version      = "1.0.1"
  s.summary      = "A customizable, Interface Builder-friendly loading indicator view."
  s.description  = "A customizable, Interface Builder-friendly loading indicator view with dots that mimics the 'typing' notifications seen in various apps. All the properties can be directly set from Interface Builder and will update in realtime (of course, animations won't play in Interface Builder), the view can be customized without writing a single line of code."
  s.homepage     = "https://github.com/canpoyrazoglu/CPProgressDotsView"

  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Can Poyrazoğlu" => "can@canpoyrazoglu.com" }
  s.social_media_url   = "http://twitter.com/canpoyrazoglu"



  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/canpoyrazoglu/CPProgressDotsView.git", :tag => s.version.to_s }


  s.source_files = "CPProgressDotsView/Classes/**/*.{h,m}"
  s.framework    = "QuartzCore"

end
