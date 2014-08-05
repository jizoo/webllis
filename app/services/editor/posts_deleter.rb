class Editor::PostsDeleter
  def delete(params)
    if params && params[:posts].kind_of?(Hash)
      ids = []
      params[:posts].values.each do |hash|
        if hash[:_destroy] == '1'
          ids << hash[:id]
        end
      end
      if ids.present?
        Post.where(id: ids).delete_all
      end
    end
  end
end
