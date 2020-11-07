import zio._
import zio.clock._
import zio.duration._

object Main extends App {
  val runZio = ZIO.effect(println("Hello, World!"))
  val runZioLater = runZio.delay(10.seconds)

  def run(args: List[String]) = {
    runZioLater.exitCode
  }
}
