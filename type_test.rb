spec = <<-CODE
describe Calculator do
  it 'adds' do
    c = Calculator.new
    c.add(1, 2).should == 3
  end
  
  it 'subtracts' do
    c = Calculator.new
    c.subtract(2,1).should == 1
  end
end
CODE

puts spec