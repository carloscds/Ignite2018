using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace coreapi.Controllers
{
    [Route("/[controller]")]
    public class MonitorController : Controller
    {
        // GET api/values
        [HttpGet]
        public string Get()
        {
            return "<html><body>OK</body></html>"; 
        }
    }
}
