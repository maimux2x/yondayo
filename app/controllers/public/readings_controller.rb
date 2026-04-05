class Public::ReadingsController < ApplicationController
  allow_unauthenticated_access

  def show
    @reading = Reading.find_by!(share_token: params[:share_token])

    set_meta_tags(
      og: {
        site_name: 'Bookshelf',
        title: @reading.book.title,
        image: @reading.book.cover.attached? ? url_for(@reading.book.cover.variant(:ogp)) : nil,
        type: 'article',
        url: request.url,
        description: '読書記録の共有'
      },
      twitter: {
        card: 'summary_large_image'
      }
    )
  end
end
