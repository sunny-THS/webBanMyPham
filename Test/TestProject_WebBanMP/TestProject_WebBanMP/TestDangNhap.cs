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
public class TestDangNhap
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
    public void dangNhap()
    {
        driver.Navigate().GoToUrl("http://localhost:63565/Auth/DangNhap");
        driver.Manage().Window.Size = new System.Drawing.Size(1552, 840);
        driver.FindElement(By.Id("floatingInputSignin")).Click();
        driver.FindElement(By.Id("floatingInputSignin")).SendKeys("tuhueson");
        driver.FindElement(By.Id("floatingPasswordSignin")).SendKeys("123456789");
        driver.FindElement(By.Id("btnSignin")).Click();
        Assert.That(driver.FindElement(By.CssSelector("#Username > span")).Text, Is.Not.EqualTo(" "));
        driver.FindElement(By.CssSelector(".fa")).Click();
    }
    [TearDown]
    public void dangNhap(string pUsername, string pPw, string pKetQuaMongDoi)
    {
        driver.Navigate().GoToUrl("http://localhost:63565/Auth/DangNhap");
        driver.Manage().Window.Size = new System.Drawing.Size(1552, 840);
        driver.FindElement(By.Id("floatingInputSignin")).Click();
        driver.FindElement(By.Id("floatingInputSignin")).SendKeys(pUsername);
        driver.FindElement(By.Id("floatingPasswordSignin")).SendKeys(pPw);
        driver.FindElement(By.Id("btnSignin")).Click();

        Thread.Sleep(1500);
        try
        {
            Assert.That(driver.FindElement(By.CssSelector("#Username > span")).Text, Is.Not.EqualTo(pKetQuaMongDoi));

            driver.FindElement(By.CssSelector(".fa")).Click(); // đăng nhập thành công
        }
        catch (Exception)
        {
            if (string.IsNullOrEmpty(pPw) || string.IsNullOrEmpty(pUsername))
                Assert.That("Vui lòng nhập đủ thông tin", Is.EqualTo(pKetQuaMongDoi)); // nhập thiểu thông tin
            else Assert.That(driver.FindElement(By.Id("swal2-title")).Text, Is.EqualTo(pKetQuaMongDoi));
        }
        finally
        {
            TearDown();
        }
    }
}
