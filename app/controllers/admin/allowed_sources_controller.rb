class Admin::AllowedSourcesController < Admin::ApplicationController
  def index
    @allowed_sources = AllowedSource.order(:octet1, :octet2, :octet3, :octet4)
    @new_allowed_source = AllowedSource.new
  end

  def create
    @new_allowed_source = AllowedSource.new(allowed_source_params)
    @new_allowed_source.namespace = 'editor'
    if @new_allowed_source.save
      flash[:success] = '許可IPアドレスを追加しました。'
      redirect_to action: 'index'
    else
      @allowed_sources =
        AllowedSource.order(:octet1, :octet2, :octet3, :octet4)
      flash.now[:danger] = '許可IPアドレスの値が正しくありません。'
      render action: 'index'
    end
  end

  # DELETE
  def delete
    if Admin::AllowedSourcesDeleter.new.delete(params[:form])
      flash[:success] = '許可IPアドレスを削除しました。'
    end
    redirect_to action: 'index'
  end

  private
  def allowed_source_params
    params.require(:allowed_source)
      .permit(:octet1, :octet2, :octet3, :last_octet)
  end
end
