class SitesController < ApplicationController
  include SitesHelper
  include Pagy::Backend

  before_action :set_site , except: [:new, :indexو :create]
  has_scope :order_by_last_visit
  has_scope :past_15, type: :boolean
  has_scope :past_30, type: :boolean
  has_scope :past_45, type: :boolean
  has_scope :past_more_than_45, type: :boolean
  has_scope :order_by_name
  has_scope :order_by_address
  has_scope :last_visit_between, using: %i[start_date end_date], type: :hash
  has_scope :name_match
  has_scope :address_match

  rescue_from Pagy::OverflowError, with: :overflow_paginations

  def index
    content = params.except(:action,:controller).values.any? ? Site.all : Site.order_by_last_visit("asc")
    @pagy, @sites = pagy(apply_scopes(content), size: [1,3,3,1])
    @query = params
  end

  def new
    @site = Site.new(last_visit: Date.today)
  end

  def show

  end

  def update
    if @site.update(sites_params)
      redirect_to root_path, notice: "تم تحديث بيانات الموقع بنجاح"
    else
      render :edit
    end
  end

  def edit
  end

  def create
    @site = Site.new(sites_params)
    if @site.save
      redirect_to root_path, notice: "تم اضافة الموقع بنجاح"
    else
      render :new
    end
  end

  def destroy
    if @site.destroy
      redirect_to root_path, notice: "تم حذف الموقع بنجاح"
    else
      redirect_to root_path, alert: "حدث خطأ أثناء تنفيذ العمليةز الرجاء المحاولة مرة اخرى"
    end
  end

  def submit_visit
    @site.update(last_visit: DateTime.now)
    redirect_to root_path, notice: "تم تحديث اخر زيارة للموقع: #{@site.name}"
  end



  private
  def sites_params
    params.require(:site).permit(:name, :address, :last_visit)
  end

  def set_site
    @site = Site.find_by(id: params[:id])
    redirect_to root_path, alert: 'الموقع المطلوب غير موجود' unless @site
  end

  def overflow_paginations
    redirect_to root_path, alert: 'الصفحة المطلوبة غير موجودة'
  end
end
