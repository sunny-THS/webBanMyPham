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
public class NhapThieuThongTinTest
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
    public void nhapThieuThongTin(string pUsername, string pPw)
    {
        // Test name: NhapThieuThongTin
        // Step # | name | target | value
        // 1 | open | http://localhost:63565/Auth/DangNhap | 
        driver.Navigate().GoToUrl("http://localhost:63565/Auth/DangNhap");
        // 2 | setWindowSize | 788x824 | 
        driver.Manage().Window.Size = new System.Drawing.Size(788, 824);
        // 3 | click | id=floatingInputSignin | 
        driver.FindElement(By.Id("floatingInputSignin")).Click();
        // 4 | type | id=floatingInputSignin |  
        driver.FindElement(By.Id("floatingInputSignin")).SendKeys(pUsername);
        // 5 | type | id=floatingPasswordSignin | 123
        driver.FindElement(By.Id("floatingPasswordSignin")).SendKeys(pPw);
        // 6 | click | id=btnSignin | 
        driver.FindElement(By.Id("btnSignin")).Click();
        // 7 | assertText | id=swal2-title | Vui lòng nhập đủ thông tin
        // đăng nhập thiếu thông tin
        Assert.That(driver.FindElement(By.Id("swal2-title")).Text, Is.EqualTo("Vui lòng nhập đủ thông tin"));
    }
}
