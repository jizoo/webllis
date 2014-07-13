class EventPresenter < ModelPresenter
  delegate :user, :description, :occurred_at, to: :object

  def table_row
    markup(:tr) do |u|
      unless view_context.instance_variable_get(:@user)
        u.td do
          u << link_to(user.name, [ :admin, user, :events ])
        end
      end
      u.td description
      u.td do
        u.text occurred_at.strftime('%Y/%m/%d %H:%M:%S')
      end
    end
  end
end
