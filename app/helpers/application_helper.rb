module ApplicationHelper
  def page_title(page_title = '')
    base_title = 'りふれっ酒'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def flash_background_color(type)
    case type.to_sym
    when :success then 'bg-success'
    when :danger  then 'bg-error'
    else 'bg-yellow-400'
    end
  end

  def default_meta_tags
    {
      site: 'りふれっ酒',
      title: 'りふれっ酒',
      reverse: true,
      charset: 'utf-8',
      description: '二日酔いで困ってませんか？',
      keywords: '二日酔い,酒,気持ち悪い',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.png') },
        { href: image_url('favicon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' }
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('favicon.png'),
        locale: 'ja-JP'
      }
    }
  end
end
