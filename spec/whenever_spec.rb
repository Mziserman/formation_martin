describe 'Whenever Schedule' do
  before do
    load 'Rakefile'
  end

  it 'makes sure rake tasks exist' do
    schedule = Whenever::Test::Schedule.new

    schedule.jobs[:rake].each do |scheduled_rake|
      expect(Rake::Task.task_defined?(scheduled_rake[:task])).to be true
    end
  end
end
