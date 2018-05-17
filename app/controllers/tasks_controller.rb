class TasksController < ApplicationController
  
  before_action :set_task, only: [:show, :edit, :update]
  before_action :require_user_logged_in 
  before_action :correct_user, only: [:destroy]
  
  def index
    @tasks =Task.all
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクは正常に登録されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at').page(params[:page])
      flash.now[:danger] = 'タスクは登録されませんでした'
      render 'toppages/index'
    end
  end
  
  def edit
  end
  
  def update

    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render 'toppages/index'
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to root_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end  
end
