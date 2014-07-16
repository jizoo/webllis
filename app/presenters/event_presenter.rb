class EventPresenter < ModelPresenter
  delegate :user, :description, :occurred_at, to: :object

  def table_row
    markup(:tr) do |m|
      unless view_context.instance_variable_get(:@user)
        m.td do
          m << link_to(user.name, [ :admin, user, :events ])
        end
      end
      m.td description
      m.td do
        m.text occurred_at.strftime('%Y/%m/%d %H:%M:%S')
      end
    end
  end
end
