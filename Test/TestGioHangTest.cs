// Generated by Selenium IDE
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.Remote;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Interactions;
using NUnit.Framework;
[TestFixture]
public class TestGioHangTest {
  private IWebDriver driver;
  public IDictionary<string, object> vars {get; private set;}
  private IJavaScriptExecutor js;
  [SetUp]
  public void SetUp() {
    driver = new ChromeDriver();
    js = (IJavaScriptExecutor)driver;
    vars = new Dictionary<string, object>();
  }
  [TearDown]
  protected void TearDown() {
    driver.Quit();
  }
  [Test]
  public void testGioHang() {
    driver.Navigate().GoToUrl("http://localhost:63565/");
    driver.Manage().Window.Size = new System.Drawing.Size(1536, 824);
    driver.FindElement(By.LinkText("Xem chi tiết")).Click();
    driver.FindElement(By.LinkText("THÊM VÀO GIỎ HÀNG")).Click();
    driver.FindElement(By.CssSelector(".nav-item > .nav-link > span")).Click();
    driver.FindElement(By.Name("txtSoLuong")).SendKeys("55");
    driver.FindElement(By.CssSelector(".btn-primary:nth-child(1)")).Click();
    Assert.That(driver.FindElement(By.Id("swal2-title")).Text, Is.EqualTo("Sản phẩm Nước Tẩy Trang L\\\'Oreal Paris S... không đủ số lượng"));
    driver.FindElement(By.CssSelector(".fa-trash-alt")).Click();
  }
}
