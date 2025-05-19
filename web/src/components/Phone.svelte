<script lang="ts">
  import Frame from "./Frame.svelte";
  import { formatMoney } from "../utils/misc";
  import "./app.css";
  import type { InvoiceProps } from "../types/invoices";
  import type { PhoneDataProps } from "../types/phone";
  import { phoneData } from "../store/stores";
  import { onMount } from "svelte";
  const { sendNotification, setPopUp, fetchNui } = window;

  function formatCardNumber(id: string) {
    let baseNumber = id.replace(/\D/g, "");
    if (baseNumber.length === 0) {
      baseNumber = Array.from(id.substring(0, 16))
        .map((char) => char.charCodeAt(0) % 10)
        .join("");
    }

    baseNumber = baseNumber.padEnd(16, "0").substring(0, 16);

    return baseNumber.replace(/(.{4})/g, "$1 ").trim();
  }

  onMount(() => {
    fetchNui("hype_banking:client:getPhoneData").then(
      (resp: PhoneDataProps) => {
        if (resp) {
          resp.id = formatCardNumber(resp.id);
          phoneData.set(resp);
        }
      }
    );
  });

  // Send money popup state
  let showSendPopup = false;
  let recipientId = "";
  let sendAmount = "";

  const handleSend = async () => {
    const resp = await fetchNui("hype_banking:client:sendMoney", { target: recipientId, amount: sendAmount });
    showSendPopup = false;
    if (resp &&resp.status === "success") {
      sendNotification({
        content: `Successfully sent ${formatMoney(Number(sendAmount))} to ${recipientId}`,
      });
      phoneData.update((prev) => ({
        ...prev,
        balance: resp.balance,
      }));
      recipientId = "";
      sendAmount = "";
    } else if (resp && resp.status === "nobalance") {
      sendNotification({
        content: `Not enough balance to send ${formatMoney(Number(sendAmount))} to ${recipientId}`,
      });
    } else if (resp && resp.status === "notarget") {
      sendNotification({
        content: `Target ${recipientId} is not a valid player`,
      });
    } 
  };

  const handlePayInvoice = async (invoice: InvoiceProps) => {
    const resp = await fetchNui("hype_banking:client:payInvoice", invoice);
    if (resp && resp.status === "success") {
      phoneData.update((prev) => ({
        ...prev,
        invoices: prev.invoices.filter(
          (inv) => inv.invoice_id !== invoice.invoice_id
        ),
      }));
      sendNotification({
        content: `Successfully paid ${formatMoney(invoice.total)} to ${invoice.author_job}`,
      });
    } else if (resp && resp.status === "nobalance") {
      sendNotification({
        content: `Not enough balance to pay ${formatMoney(invoice.total)} to ${invoice.author_job}`,
      });
    }
    setPopUp(null)
  };
</script>

<Frame>
  <div class="app-wrapper bg-fleeca-bg text-fleeca-text h-full flex flex-col">
    <!-- Header Section -->
    <div
      class="pt-8 w-full px-6 pb-4 bg-gradient-to-b from-fleeca-card to-fleeca-bg"
    >
      <div class="w-full flex flex-col items-center pt-8">
        <h1 class="text-2xl font-semibold mb-2">Banking</h1>
        <p class="text-sm text-fleeca-text-secondary">Available Balance</p>
        <p class="text-3xl font-bold text-fleeca-green">
          {formatMoney($phoneData.balance)}
        </p>
      </div>
    </div>

    <!-- Content Section -->
    <div class="flex-1 flex flex-col gap-2 overflow-hidden px-4 py-2">
      <!-- Card Section -->
      <h2 class="text-lg font-medium mb-3">Your Card</h2>
      <div class="transform transition-transform hover:scale-[1.02]">
        <div
          class="w-full bg-gradient-to-br from-fleeca-green to-fleeca-dark-green rounded-xl p-4 text-white shadow-lg"
        >
          <!-- Card Header -->
          <div class="flex justify-between items-start mb-4">
            <div class="flex items-center gap-2">
              <i class="fas fa-university"></i>
              <span class="font-bold">FLEECA</span>
            </div>
            <div class="text-xs font-semibold px-2 py-1 bg-white/20 rounded">
              PERSONAL
            </div>
          </div>

          <!-- Card Number -->
          <div class="font-mono text-lg mb-4 tracking-wider">
            {$phoneData.id}
          </div>

          <!-- Card Footer -->
          <div class="flex justify-between items-end">
            <div>
              <p class="text-xs opacity-80">CARD HOLDER</p>
              <p class="font-medium">{$phoneData.name}</p>
            </div>
            <div class="text-right">
              <p class="text-xs opacity-80">BALANCE</p>
              <p class="font-medium">{formatMoney($phoneData.balance)}</p>
            </div>
          </div>
        </div>
      </div>

      <button
        class="w-full h-10 rounded-md text-white bg-fleeca-hover hover:text-fleeca-light-green text-lg"
        on:click={() => (showSendPopup = true)}
      >
        Send
      </button>

      <!-- Pending Invoices Section -->
      <h2 class="text-lg font-medium mb-3">Pending Invoices</h2>
      <div class="flex-1 overflow-y-auto custom-scrollbar">
        {#if $phoneData.invoices.length > 0}
          <div class="space-y-3">
            {#each $phoneData.invoices as invoice}
              <div
                class="bg-fleeca-card rounded-lg p-4 border border-fleeca-border"
              >
                <div class="flex justify-between items-start mb-2">
                  <div>
                    <h3 class="font-medium">{invoice.author_job}</h3>
                    <p class="text-sm text-fleeca-text-secondary">
                      {invoice.item}
                    </p>
                  </div>
                  <p class="text-fleeca-red font-medium">
                    {formatMoney(invoice.total)}
                  </p>
                </div>
                <div class="flex justify-between items-center">
                  <p class="text-xs text-fleeca-text-secondary">
                    {new Date(invoice.created_date * 1000).toLocaleDateString()}
                  </p>
                  <button
                    class="text-sm text-fleeca-green hover:text-fleeca-dark-green transition-colors"
                    on:click={() => {
                      setPopUp({
                        title: "Pay Invoice",
                        description: `Are you sure you want to pay ${invoice.total} to ${invoice.author_job}?`,
                        buttons: [
                          {
                            title: "Cancel",
                            color: "red",
                            cb: () => {
                              setPopUp(null);
                            },
                          },
                          {
                            title: "Pay",
                            color: "green",
                            cb: () => {
                              handlePayInvoice(invoice);
                            },
                          },
                        ],
                      });
                    }}
                  >
                    Pay Now
                  </button>
                </div>
              </div>
            {/each}
          </div>
        {:else}
          <div class="text-center py-4 text-fleeca-text-secondary">
            <p>No pending invoices</p>
          </div>
        {/if}
      </div>
    </div>
  </div>

  <!-- Send Money Popup -->
  {#if showSendPopup}
    <div class="fixed inset-0 bg-black/50 flex items-center justify-center p-4">
      <div class="bg-fleeca-bg rounded-lg p-6 w-full max-w-sm">
        <h3 class="text-xl font-semibold mb-4">Send Money</h3>
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-1" for="playerId"
              >Player ID</label
            >
            <input
              type="text"
              id="playerId"
              bind:value={recipientId}
              class="w-full px-3 py-2 bg-fleeca-card border border-fleeca-border rounded-md focus:outline-none focus:border-fleeca-green"
              placeholder="Enter player ID"
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-1" for="amount"
              >Amount</label
            >
            <input
              type="number"
              id="amount"
              bind:value={sendAmount}
              class="w-full px-3 py-2 bg-fleeca-card border border-fleeca-border rounded-md focus:outline-none focus:border-fleeca-green"
              placeholder="Enter amount"
            />
          </div>
          <div class="flex gap-3 mt-6">
            <button
              class="flex-1 px-4 py-2 bg-fleeca-hover text-white rounded-md hover:bg-fleeca-green transition-colors"
              on:click={() => handleSend()}
            >
              Send
            </button>
            <button
              class="flex-1 px-4 py-2 bg-fleeca-card border border-fleeca-border rounded-md hover:bg-fleeca-hover transition-colors"
              on:click={() => (showSendPopup = false)}
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  {/if}
</Frame>

<style>
  /* Custom Scrollbar Styles */
  :global(.custom-scrollbar) {
    scrollbar-width: thin;
    scrollbar-color: theme("colors.fleeca.border") theme("colors.fleeca.card");
  }

  :global(.custom-scrollbar::-webkit-scrollbar) {
    width: 6px;
  }

  :global(.custom-scrollbar::-webkit-scrollbar-track) {
    background: theme("colors.fleeca.card");
    border-radius: 3px;
  }

  :global(.custom-scrollbar::-webkit-scrollbar-thumb) {
    background-color: theme("colors.fleeca.border");
    border-radius: 3px;
  }

  :global(.custom-scrollbar::-webkit-scrollbar-thumb:hover) {
    background-color: theme("colors.fleeca.hover");
  }
</style>
