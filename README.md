<p align="center">
  <img src="https://cdn.twikey.net/img/v2/partners/businesscentraltwikey.png"  height="128"/>
</p>
<h1 align="center">Twikey integration for Microsoft Dynamics 365 Business Central</h1>

* * *

The Twikey plugin provides a convenient integration with Twikey, **a payment service provider specializing in recurring payments and payments for returning customers**.

Installing the Twikey plugin in Business Central allows an automated and efficient financial workflow whether you use the accountancy and ERP functionalities of Business Central or use Business Central as an invoice generation tool, this plugin allows you as well as your customer to make the payment process as painless as possible. It does this in several ways:

*   **Invite your customers to a recurring payment method** whether it's via direct debit or credit card reducing your financial costs as well as improving your cash flow as the predictable nature of recurring payments (and direct debit in particular) allows businesses to accurately forecast and plan their incoming cash flow.
*   Mandate Management: Twikey offers a comprehensive solution for **managing mandates**. With the Twikey plugin, merchants can efficiently handle the creation, modification, and cancellation of mandates directly from within Business Central. This simplifies mandate management and ensures compliance with relevant regulations.
*   The existing Sepa mandates as well as any recurring credit card token of your customer can be used for **registering payments** either in a customer checkout or when you're on your monthly billing run. The heavy lifting of swiftly delivering all transactions to one or more banks/payment providers is being done automatically in Twikey where during setup you can configure any of the existing connections.
*   Direct Debit Payments: Via Twikey's gateway to multiple banks, the invoices can be automatically debited directly from your customer's bank accounts **without the need to ever download/upload files in your bank environment**.
*   The plugin also reduces the operational overhead by **leveraging the reconciliation engine of Business Central** as well as providing the reconciliation files for use in third-party accounting software, reducing the need for manual intervention and minimizing errors. This automation saves time and resources, allowing businesses to focus on core activities while maintaining accurate and up-to-date payment records.
*   Automatically synchronize payment information between Twikey and Business Central, enabling your business to maintain accurate records and monitor the status of payments. This simplifies the reconciliation process even further and enhances financial visibility.
*   Customizable to the workflow desired by you.

In summary, installing the Twikey plugin in Business Central provides you with a comprehensive solution for recurring payment management, mandate handling, and automation. It streamlines payment processes, improves operational efficiency, and facilitates seamless integration with Business Central's existing functionalities.

Once installed
--------------

Once the plugin is installed, you'll be able to do the following:

*   invite a specific customer to do their payments via Direct Debit instead of costly creditcard
*   automatically allow all customers to sign a recurring payment on every invoice
*   include a qr code going to the Twikey payment page where the state of the invoice is immediately visible
*   Have an overview of all the newly signed Twikey documents in Business Central
*   provide qr codes usable in belgian bank apps
*   automatically generate any type of payment link on an invoice via the Twikey payment hub
*   payment tokens are registered automatically on you customer in Business Central
*   have the option to allow your customer to pay manually even when an automatic method is available
*   allow the routing of multiple bank accounts for direct debit collection
*   define multiple payment solutions for different payment methods


Configuration
-------------

After installing the plugin your integrator can head to the settings and paste the api url and key they copied from the [Twikey Api settings](https://www.twikey.com/r/admin/#/c/settings/api).

*   Define whether you are connecting to a production or test environment
*   We recommend enabling the logging function in Business Central
*   Be sure to test the connectivity ensuring there is no network issue between your Business Central environment and Twikey
*   After synchronising the Twikey profiles get familiarize yourself with the possible workflows
*   Generate an invoice and invite yourself to pay to experience your customer journey for yourself.

Installation - Support
----------------------

For installation support, contact your own integrator who installed your Business Central set-up.
The full documentation can be found in the Business Central store itself.

Or contact one of our partners: [Twikey Business Central integrators](https://www.twikey.com/partner/businesscentral.html)