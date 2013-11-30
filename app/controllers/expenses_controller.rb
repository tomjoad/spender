class ExpensesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @expenses = current_user.expenses.paginate(:page => params[:page], :per_page => 50).order('created_at DESC')
  end

  def new
    @expense = Expense.new
  end

  def destroy
    @expense = current_user.expenses.find(params[:id])
    @expense.destroy
    redirect_to expenses_path
  end

  def create
    @expense = current_user.expenses.new(params[:expense])
    if @expense.save
      redirect_to expenses_path
    else
      render 'new'
    end
  end

  def update
    @expense = current_user.expenses.find(params[:id])
    if @expense.update_attributes(params[:expense])
      redirect_to expenses_path
    else
      render 'edit'
    end
  end

  def edit
    @expense = current_user.expenses.find(params[:id])
  end

end
