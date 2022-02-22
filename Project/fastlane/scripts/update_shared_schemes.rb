#!/usr/bin/env ruby
# share_schemes.rb

require 'xcodeproj'

## XCConfig files ##
# PRODUCT_NAME = PL-INTERN-$(MARKETING_VERSION) (Defined in xcconfig file)
# return PL-INTERN
def extractProductNameFromConfigFile(configPath, xcconfigFileName)
    begin
        config = Xcodeproj::Config.new(configPath + xcconfigFileName + ".xcconfig")
        productNameValue = config.attributes["PRODUCT_NAME"]
        removeToIndex = productNameValue.index("-$(MARKETING_VERSION)")
        productName = productNameValue[0..removeToIndex-1]
    rescue
        puts "Exception: Unable to take the product name"
    end
    return productName
end

# This function is combining buildConfiguration in XCScheme with XCConfig file PRODUCT_NAME
# to buid the buildable_name that will be used to update the old one
# returns buildable name that will be saved (PL-INTERN-0.2.2.app)
def newBuildableName(configPath, buildConfiguration, version)
    configFileName = extractConfigFileNameFrom(buildConfiguration)
    productName = extractProductNameFromConfigFile(configPath, configFileName)
    return productName(productName, version)
end

# buildConfiguration = "Intern-Debug"
# return "Intern"
def extractConfigFileNameFrom(buildConfiguration)
    slashIndex = buildConfiguration.index("-")
    begin
        configFileName = buildConfiguration[0..slashIndex-1]
    rescue
        puts "Exception: Not found configFileName"
    end
    return configFileName
end

# return PL-INTERN-0.2.2.app
def productName(productName, version)
    begin
        return productName + "-" + version + ".app"
    rescue
        puts "Exception: Unable to create product name"
    end
end


## XCScheme ##
def update_scheme(configPath, project, scheme, version)
    puts "Modifying XCScheme:" + scheme

    # Open scheme
    scheme_path = Xcodeproj::XCScheme.shared_data_dir(project.path) + scheme
    scheme = Xcodeproj::XCScheme.new(scheme_path)

    # BuildAction
    buildAction = scheme.build_action.entries[0].buildable_references[0]
    # LaunchAction
    launchAction = scheme.launch_action.buildable_product_runnable.buildable_reference
    # ProfileAction
    profileAction = scheme.profile_action.buildable_product_runnable.buildable_reference
    # TestAction
    # Does not contain BuildableName

    # buildConfiguration contains the configuration used (i.e. Intern-Debug, Pro-Release)
    buildConfiguration = scheme.analyze_action.build_configuration
    buildableName = newBuildableName(configPath, buildConfiguration, version)

    if buildableName
        [buildAction, launchAction, profileAction].each do |buildable_reference|
            buildable_reference.buildable_name = buildableName
        end

        scheme.save!
    end
end

# Loops all schemes in shared xcshareddata/xcschemes
def update_schemes(configPath, projectPath, version)
    puts "update_schemes DIR: " + Dir.pwd
    begin
        project = Xcodeproj::Project.open(projectPath)
    rescue
        puts "Exception: Unable to open the project with path " + project_path
    end
    shared_data_dir = Xcodeproj::XCScheme.shared_data_dir(project.path)
    Dir.foreach(shared_data_dir) do |filename|
        next if not filename.include? "xcscheme"
        update_scheme(configPath, project, filename, version)
    end
end
