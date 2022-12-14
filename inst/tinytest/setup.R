
using("checkmate")
checkmate::register_test_backend("tinytest")

library("data.table")
loadNamespace("mlr3")
loadNamespace("bbotk")

lgr::get_logger("mlr3")$set_threshold("warn")
lgr::get_logger("bbotk")$set_threshold("warn")

options(miesmuschel.testing = TRUE)


for (helper in list.files(pattern = "^helper_.*\\.R$")) {
  source(helper, local = TRUE)
}
