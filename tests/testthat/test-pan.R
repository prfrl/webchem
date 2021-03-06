up <- ping_service("pan")
test_that("pan_query()", {
  skip_on_cran()
  skip_if_not(up, "PAN service is down, skipping tests")

  a <- pan_query(c('Triclosan','Chlorpyrifos', 'xxxx', NA), match = 'best', verbose = FALSE)
  b <- pan_query(c('Triclosan','Chlorpyrifos', 'xxxx', NA), match = 'all', verbose = FALSE)
  c <- pan_query(c('Triclosan','Chlorpyrifos', 'xxxx', NA), match = 'first', verbose = FALSE)

  expect_s3_class(a, 'list')
  expect_s3_class(b, 'list')
  expect_s3_class(c, 'list')
  expect_length(a, 4)
  expect_length(b, 4)
  expect_length(c, 4)
  expect_length(a[[1]], 75)
  expect_length(b[[2]], 75)
  expect_length(c[[2]], 75)
  expect_length(a[[1]]$`CAS Number`, 1)
  expect_length(b[[2]]$`CAS Number`, 9)
  expect_length(c[[2]]$`CAS Number`, 1)
  expect_true(is.na(a[[3]]))
  expect_true(is.na(b[[3]]))
  expect_true(is.na(c[[3]]))
  expect_true(is.na(a[[4]]))
  expect_true(is.na(b[[4]]))
  expect_true(is.na(c[[4]]))
  expect_equal(a[[1]]$`CAS Number`, "3380-34-5")
  expect_equal(a[[2]]$`Chemical name`, "Chlorpyrifos")
})
