# Filling in the gaps with the Adapter

![If it looks like a duck, quacks like a duck...](./duck_typing.jpg)



# Beat it into submission

~~~
@@@ruby

bto = BritishTextObject('hello', 50.8, :blue)

class << bto
  def text
    string
  end
end
~~~
