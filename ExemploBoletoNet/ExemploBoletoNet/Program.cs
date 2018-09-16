using BoletoNet;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExemploBoletoNet
{
    class Program
    {
        static void Main(string[] args)
        {
            ImprimeBoleto(1);
        }

        private static void ImprimeBoleto(int i)
        {
            Boleto boleto = new Boleto();
            boleto.Cedente = new Cedente("00.000.000/0000-00", "Empresa XPTO Ltda.", "3118", "6", "0001567", "9");
            var enderecoCedente = new Endereco();
            enderecoCedente.Bairro = "Testando / " + i.ToString();
            enderecoCedente.End = "SSS 154 Bloco J Casa 23 / " + i.ToString();
            enderecoCedente.Cidade = "Testelândia / " + i.ToString();
            enderecoCedente.CEP = "70000000";
            enderecoCedente.UF = "DF";
            boleto.Cedente.Endereco = enderecoCedente;

            var sacado = new Sacado("000.000.000-00", "Fulano de Tal 1/ " + i.ToString());
            var endereco = new Endereco();
            endereco.Bairro = "Testando / " + i.ToString();
            endereco.End = "SSS 154 Bloco J Casa 23 / " + i.ToString();
            endereco.Cidade = "Testelândia / " + i.ToString();
            endereco.CEP = "70000000";
            endereco.UF = "DF";
            sacado.Endereco = endereco;

            boleto.Sacado = sacado;
            boleto.DataDocumento = DateTime.Now.AddDays(-3);
            boleto.DataProcessamento = DateTime.Now;
            boleto.DataVencimento = DateTime.Now.AddDays(15);

            boleto.DataDesconto = boleto.DataVencimento;
            boleto.ValorBoleto = 500;
            boleto.ValorDesconto = 10;

            boleto.NumeroDocumento = "BB123456 / " + i.ToString();
            boleto.NossoNumero = (123456 + i).ToString();

            boleto.Carteira = "1";
            boleto.VariacaoCarteira = "";

            boleto.Instrucoes.Add(new Instrucao_Bradesco(1));
            boleto.Banco = new Banco(748);
            boleto.EspecieDocumento = new EspecieDocumento_Bradesco("1");
            boleto.Valida();
            try
            {
                BoletoBancario imprimeBoleto = new BoletoBancario();
                imprimeBoleto.CodigoBanco = (short)boleto.Banco.Codigo;
                imprimeBoleto.OcultarInstrucoes = false;
                imprimeBoleto.Boleto = boleto;
                imprimeBoleto.MostrarComprovanteEntrega = true;
                imprimeBoleto.MostrarEnderecoCedente = true;
                imprimeBoleto.Boleto = boleto;
                imprimeBoleto.MontaHtmlNoArquivoLocal(@"c:\temp\boleto.htm");

                var pdf = imprimeBoleto.MontaBytesPDF(true);
                var arquivo = @"c:\temp\boleto.pdf";
                if (File.Exists(arquivo))
                {
                    File.Delete(arquivo);
                }
                FileStream fs = new FileStream(arquivo, FileMode.Create);
                fs.Write(pdf, 0, pdf.Length);
                fs.Close();


            }
            catch (Exception ex)
            {
                var erro = "";
                while(ex != null)
                {
                    erro += ex.Message + "\n";
                    ex = ex.InnerException;
                }

            }

        }
    }
}