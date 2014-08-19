class FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:favorite][:post_id])
    current_user.add_favorite!(@post)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def destroy
    @post = Favorite.find(params[:id]).post
    current_user.remove_favorite!(@post)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
end
