class ArticlesController < ApplicationController
  before_action :authenticate_user!
  def index
    @articles = Article.all
    @pagy, @users = pagy(User.all)
  end

  def show
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      render :new, alert: "Error"
    end
  end

  def edit
  end

  def new
    @article = authorize Article.new
  end
  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
