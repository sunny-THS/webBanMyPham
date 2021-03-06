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
public class DangNhapThatBaiTest
{
    private IWebDriver driver;
    public IDictionary<string, object> vars { get; private set; }
    private IJavaScriptExecutor js;
    [SetUp]
    public void SetUp()
    {
        driver = new ChromeDriver(@"D:\github\webBanMyPham\Test");
        js = (IJavaScriptExecutor)driver;
        vars = new Dictionary<string, object>();
    }
    [TearDown]
    public void TearDown()
    {
        driver.Quit();
    }
    [Test]
    public void dangNhapThatBai()
    {
        // Test name: DangNhapThatBai
        // Step # | name | target | value
        // 1 | open | /Auth/DangNhap | 
        driver.Navigate().GoToUrl("http://localhost:63565/Auth/DangNhap");
        // 2 | setWindowSize | 1552x840 | 
        driver.Manage().Window.Size = new System.Drawing.Size(1552, 840);
        // 3 | click | id=floatingInputSignin | 
        driver.FindElement(By.Id("floatingInputSignin")).Click();
        // 4 | type | id=floatingInputSignin | 123
        driver.FindElement(By.Id("floatingInputSignin")).SendKeys("123");
        // 5 | type | id=floatingPasswordSignin | 654
        driver.FindElement(By.Id("floatingPasswordSignin")).SendKeys("654");
        // 6 | click | id=btnSignin | 
        driver.FindElement(By.Id("btnSignin")).Click();
        // 7 | click | id=swal2-title | 
        driver.FindElement(By.Id("swal2-title")).Click();
        // 8 | assertText | id=swal2-title | Thông tin đăng nhập không chính xác.
        // đăng nhập thất bại
        Assert.That(driver.FindElement(By.Id("swal2-title")).Text, Is.EqualTo("Thông tin đăng nhập không chính xác."));
    }
    public void dangNhapThatBai(string pUsername, string pPw)
    {
        // Test name: DangNhapThatBai
        // Step # | name | target | value
        // 1 | open | /Auth/DangNhap | 
        driver.Navigate().GoToUrl("http://localhost:63565/Auth/DangNhap");
        // 2 | setWindowSize | 1552x840 | 
        driver.Manage().Window.Size = new System.Drawing.Size(1552, 840);
        // 3 | click | id=floatingInputSignin | 
        driver.FindElement(By.Id("floatingInputSignin")).Click();
        // 4 | type | id=floatingInputSignin | 123
        driver.FindElement(By.Id("floatingInputSignin")).SendKeys(pUsername);
        // 5 | type | id=floatingPasswordSignin | 654
        driver.FindElement(By.Id("floatingPasswordSignin")).SendKeys(pPw);
        // 6 | click | id=btnSignin | 
        driver.FindElement(By.Id("btnSignin")).Click();
        // 7 | click | id=swal2-title | 
        driver.FindElement(By.Id("swal2-title")).Click();
        // 8 | assertText | id=swal2-title | Thông tin đăng nhập không chính xác.
        // đăng nhập thất bại
        Assert.That(driver.FindElement(By.Id("swal2-title")).Text, Is.EqualTo("Thông tin đăng nhập không chính xác."));
    }
}
