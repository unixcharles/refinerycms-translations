class Admin::TranslationsController < Admin::BaseController

  crudify :translation, :title_attribute => :name, :order => "fresh, updated_at DESC, name ASC"
  
private  
  def paginate_all_translations
    if params[:language]
      @translations = Translation.where(:locale => params[:language])
    else
      @translations = Translation
    end

    @translations.order("fresh, updated_at DESC, name ASC").paginate :page => params[:page]
  end
end
