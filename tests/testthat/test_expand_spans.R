context("Correct expansion of header elements")

tab1_code <- '
<table>
  <tr>
    <th rowspan="2">a</th>
    <th>b</th>
    <th>c</th>
  </tr>
  <tr>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1</td>
    <td>2</td>
    <td>3</td>
  </tr>
</table>'

test_that("Correctly expanded", {

  tab1 <- XML::htmlParse(tab1_code)
  tab1 <- htmltab(tab1, header = 1:2, body = 3)

  expect_that(tab1[,1], equals("1"))
  expect_that(tab1[,2], equals("2"))
  expect_that(tab1[,3], equals("3"))

  expect_that(colnames(tab1)[1], equals("a"))
  expect_that(colnames(tab1)[2], equals("b"))
  expect_that(colnames(tab1)[3], equals("c"))
})

tab2_code <- '<table>
  <tr>
    <th rowspan="2">a</th>
<th>b</th>
<th colspan="2" rowspan="2">c</th>
</tr>
<tr>
<td></td>
</tr>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
<td></td>
</tr>
</table>'

test_that("Correctly expanded", {

  tab2 <- XML::htmlParse(tab2_code)
  tab2 <- htmltab(tab2, header = 1:2, body = 3)

  expect_that(tab2[,1], equals("1"))
  expect_that(tab2[,2], equals("2"))
  expect_that(tab2[,3], equals("3"))
  #expect_that(tab2[,4], equals(""))

  expect_that(colnames(tab2)[1], equals("a"))
  expect_that(colnames(tab2)[2], equals("b"))
  expect_that(colnames(tab2)[3], equals("c"))
  #expect_that(colnames(tab2)[4], equals("c"))
})


tab3_code <- '<table>
  <tr>
    <th>a</th>
<th>b</th>
<th>c</th>
<th colspan="3">d</th>
</tr>
<tr>
<td colspan="4">e</td>
</tr>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
<td></td>
</tr>
</table>'

test_that("Correctly expanded", {

  tab3 <- XML::htmlParse(tab3_code)
  tab3 <- htmltab(tab3, header = 1:2, body = 3)

  expect_that(tab3[,1], equals("1"))
  expect_that(tab3[,2], equals("2"))
  expect_that(tab3[,3], equals("3"))
  expect_that(is.na(tab3[,4]), is_true())

  expect_that(colnames(tab3)[1], equals("a >> e"))
  expect_that(colnames(tab3)[2], equals("b >> e"))
  expect_that(colnames(tab3)[3], equals("c >> e"))
  expect_that(colnames(tab3)[4], equals("d >> e"))
})

tab4_code <- '<table>
  <tr>
    <th rowspan="2">a</th>
<th colspan="2">b</th>
<th rowspan="2">c</th>
</tr>
<tr>
<td>b1</td>
<td>b2</td>
</tr>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
<td>4</td>
</tr>
</table>'

test_that("Correctly expanded", {

  tab4 <- XML::htmlParse(tab4_code)
  tab4 <- htmltab(tab4, header = 1:2, body = 3)

  expect_that(tab4[,1], equals("1"))
  expect_that(tab4[,2], equals("2"))
  expect_that(tab4[,3], equals("3"))
  expect_that(tab4[,4], equals("4"))

  expect_that(colnames(tab4)[1], equals("a"))
  expect_that(colnames(tab4)[2], equals("b >> b1"))
  expect_that(colnames(tab4)[3], equals("b >> b2"))
  expect_that(colnames(tab4)[4], equals("c"))
})

tab5_code <- '<table>
  <tr>
    <th rowspan="2">a</th>
<th colspan="2">b</th>
<th rowspan="40">c</th>
</tr>
<tr>
<td>b1</td>
<td>b2</td>
</tr>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
<td>4</td>
</tr>
</table>'

test_that("Correctly expanded when misspecified header", {

  tab5 <- XML::htmlParse(tab5_code)
  tab5 <- htmltab(tab5, header = 1:2, body = 3)

  expect_that(tab5[,1], equals("1"))
  expect_that(tab5[,2], equals("2"))
  expect_that(tab5[,3], equals("3"))
  expect_that(tab5[,4], equals("4"))

  expect_that(colnames(tab5)[1], equals("a"))
  expect_that(colnames(tab5)[2], equals("b >> b1"))
  expect_that(colnames(tab5)[3], equals("b >> b2"))
  expect_that(colnames(tab5)[4], equals("c"))
})


tab6_code <- '<table>
<tr>
<th rowspan="2">a</th>
<th colspan="2">b</th>
<th rowspan="40">c</th>
</tr>
<tr>
<td>b1</td>
<td>b2</td>
</tr>

<tbody>
<tr>
<td>1</td>
<td>2</td>
<td>3</td>
<td>4</td>
</tr>
</tbody>

</table>'

test_that("H: tr/th.td, B: tbody/tr; misspecified rowspan in H", {

  tab6 <- XML::htmlParse(tab6_code)
  tab6 <- htmltab(tab6, header = 1:2)

  expect_that(tab6[,1], equals("1"))
  expect_that(tab6[,2], equals("2"))
  expect_that(tab6[,3], equals("3"))
  expect_that(tab6[,4], equals("4"))

  expect_that(colnames(tab6)[1], equals("a"))
  expect_that(colnames(tab6)[2], equals("b >> b1"))
  expect_that(colnames(tab6)[3], equals("b >> b2"))
  expect_that(colnames(tab6)[4], equals("c"))
})
