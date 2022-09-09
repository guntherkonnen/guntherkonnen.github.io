# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

class Middleman::Tailwind::Main < Middleman::Extension
  # Patch to produce source/stylesheets/tailwind.css prior to build process.
  # Identical logic to #after_configuration
  def before_build(builder)
    exe = File.join(@gem_dir, "exe/#{executable}")
    cmd = "#{exe} -c #{config_file} -i #{application_css} -o #{destination}"

    return if app.mode?(:server)

    puts "Building Tailwind CSS..."
    system(cmd, out: $stdout)
  end
end

data_languages = JSON.parse(File.read("./data/languages.json"))
data_articles = JSON.parse(File.read("./data/articles.json"))
data_subjects = JSON.parse(File.read("./data/subjects.json"))

activate :tailwind do |config|
  config.config_path = "tailwind.config.js"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/
module Helpers
  module_function

  def subjects_for_language(language_param, data_languages:, data_articles:, data_subjects:)
    language_id =
      data_languages
        .find { |language| language["param"] == language_param }
        .fetch("id")

    subject_ids =
      data_articles
        .select { |article| article["language_id"] == language_id }
        .map { |article| article["subject_id"] }
        .to_set

    data_subjects
      .select { |subject| subject_ids.include?(subject["id"]) }
  end
end

helpers do
  include Helpers

  def download_for_article(article, data_downloads:)
    data_downloads.find { |download| download["id"] == article["download_id"] }
  end
end

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/
data_languages.each do |language|
  subjects = Helpers.subjects_for_language(
    language["param"],
    data_languages:,
    data_articles:,
    data_subjects:
  )

  subjects.each do |subject|
    current_articles =
      data_articles
        .select { |article| article["subject_id"] == subject["id"] && article["language_id"] == language["id"] }

    proxy(
      "/#{language["param"]}/articles/#{subject["param"]}.html",
      "/articles.html",
      locals: {
        current_language: language,
        current_subject: subject,
        articles: current_articles,
        title: "#{subject["name"]} (#{language["name"]})",
        description: (
          if language["param"] == "nl"
            "Artikelen over #{subject["name"]}"
          else
            "Articles on #{subject["name"]}"
          end
        )
      },
      ignore: true
    )
  end
end

data_articles.each do |article|
  language = data_languages.find {|language| language["id"] == article["language_id"]}

  proxy(
    "/articles/#{article["id"]}-#{article["title"].parameterize}.html",
    "/article.html",
    locals: {
      article: article,
      title: article["title"],
      description: ERB::Util.html_escape(Sanitize.fragment(article["content"])).strip,
      current_language: language
    },
    ignore: true
  )
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
