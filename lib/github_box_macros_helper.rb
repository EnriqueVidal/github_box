require 'net/http'
require 'yaml'

module GithubBoxMacrosHelper
  def get_repository_data(username)
    response    = Net::HTTP.get(URI.parse("http://github.com/api/v2/yaml/repos/show/#{username}"))
    @repository = YAML::load(response) rescue nil
  end

  def show_github_repository_box(username, options={})
    get_repository_data(username) if @repository.blank?

    list_items = @repository['repositories'].collect do |repository|
      description = content_tag('span', ' | ' + repository[:description])

      created_at  = content_tag('span', 'created at: '  + repository[:created_at].strftime("%d %b %Y"), :class => :date) if options[:created_at]
      pushed_at   = content_tag('span', 'pusehd at: '   + repository[:pushed_at].strftime("%d %b %Y"),  :class => :date) if options[:pushed_at]

      forks     = content_tag('span', '<strong>forks:</strong> '    + repository[:forks].to_s,    :class => :more_info) if options[:forks]
      watchers  = content_tag('span', '<strong>watchers:</strong> ' + repository[:watchers].to_s, :class => :more_info) if options[:watchers]

      link        = link_to repository[:name], repository[:url], :target => :_blank
      content_tag('li', link + description + watchers.to_s + forks.to_s + pushed_at.to_s + created_at.to_s, :class => :repository)
    end rescue ''

    unordered_list =  content_tag('ul', list_items, :class => 'repository_list')
    content_tag('div', unordered_list, :class => 'github_box')
  end

  def include_github_box_if_needed
    stylesheet_link_tag "github_box/style.css" if @uses_github_box
  end
end

