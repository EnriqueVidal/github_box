module GithubBox
  def self.included(base)
    base.extend(ClassMethods)
  end

  def self.initialize
    return if @initialized
    ActionController::Base.send(:include, GithubBox)
    ActionController::Base.helper GithubBoxMacrosHelper

    GithubBox.install
    @initialized = true
  end

  def self.install
    require 'fileutils'
    original_stylesheets  = File.join(File.dirname(__FILE__), 'github_box', 'assets', 'stylesheets', 'github_box')
    destination           = File.join(Rails.root.to_s, 'public', 'stylesheets', 'github_box')
    final_stylesheet      = File.join( destination, 'style.css' )

    unless File.exists?(destination) && FileUtils.identical?( File.join( original_stylesheets, 'style.css'), final_stylesheet )
      if !File.exists?( final_stylesheet )
        begin
          puts "Creating directory #{destination}..."
          FileUtils.mkdir_p destination
          puts "Copying GithubBox CSS to #{destination}..."
          FileUtils.cp_r "#{original_stylesheets}/.", destination
          puts "Succesfully copied GithubBox."
        rescue
          puts "ERROR: Problem installing GithubBox. Please manually copy "
          puts final_stylesheet
          puts "to"
          puts destination
        end
      end
    end
  end

  module ClassMethods
    def uses_github_box(options = {})
      proc = Proc.new do |current_class|
        current_class.instance_variable_set(:@uses_github_box, true)
      end

      before_filter(proc, options)
    end
  end
end

