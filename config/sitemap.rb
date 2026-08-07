SitemapGenerator::Sitemap.default_host = "https://arogyam.life"
SitemapGenerator::Sitemap.search_engines = {}

SitemapGenerator::Sitemap.create do
  # Static pages
  add root_path, changefreq: 'weekly', priority: 1.0
  add about_path, changefreq: 'monthly', priority: 0.7
  add programmes_path, changefreq: 'weekly', priority: 0.9
  add blogs_path, changefreq: 'weekly', priority: 0.8
  add testimonials_path, changefreq: 'monthly', priority: 0.6
  add accommodation_path, changefreq: 'monthly', priority: 0.6
  add donate_path, changefreq: 'monthly', priority: 0.7
  add contacts_path, changefreq: 'monthly', priority: 0.5
  add privacy_policy_path, changefreq: 'yearly', priority: 0.2

  # Dynamic pages - Health Programmes
  Package.find_each do |package|
    add programme_path(package), lastmod: package.updated_at, changefreq: 'weekly', priority: 0.8
  end

  # Dynamic pages - Blog posts
  Blog.find_each do |blog|
    add blog_path(blog), lastmod: blog.updated_at, changefreq: 'monthly', priority: 0.7
  end
end
