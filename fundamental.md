Фундаментальные шаблоны проектирования
==========
## Интерфейс  

### Похожие типы шаблонов  
* Мост  
* Компоновщик  
* Фасад  
* Адаптер  
* Делегирование  

### Классы и интерфейсы
* класс реализующий методы для манипулирования другимим объектами  

Это `класс` который обеспечивает выскоуровневую функциональность. Может содержать множество объектов которые вызываются одним методом, этим достигается высокоуровнеовое управление.  

```php
  <?
    class InterfaceCar{
      protected $car;
      function __construct(Car $car){
        $this->car = $car;
      }
      function startEngine(){
        $car = $this->car;
        $car->parkingBrake->down();
        $car->transmission->neutral();
        $car->engine->start();
      }
      function moveUp(){
        $car = $this->car;
        $car->grip->up();
        $car->transmission->first();
        $car->engine->gas(30);
        $car->grip->down();
      } 
      function moveBack(){
        $car = $this->car;
        $car->grip->up();
        $car->transmission->reverse();
        $car->engine->gas(30);
        $car->grip->down();
      }
      function stopEngine(){
        $car = $this->car;
        $car->grip->up();
        $car->transmission->neutral();
        $car->engine->stop();
        $car->parkingBrake->up();
      }
    }
  ?>
```
