module PaginationHelper
  def pagination_for(*args)
    pagination = paginate(*args)
    render 'kaminari/streaming_paginator', pagination: pagination
  end
end
