<script lang="ts">
  import VisibilityProvider from "./providers/VisibilityProvider.svelte";
  import { debugData } from "./utils/debugData";
  import AccountsContainer from "./components/AccountsContainer.svelte";
  import Popup from "./components/Popup.svelte";
  import Loading from "./components/Loading.svelte";
  import Notification from "./components/Notification.svelte";
  import { popupDetails, loading, notify, accounts, page } from "./store/stores";
  import { onMount } from "svelte";
  import InvoicesContainer from "./components/InvoicesContainer.svelte";
  let bodyClass = 'font-sans text-fleeca-text bg-transparent';
  onMount(() => {
    document.body.className = bodyClass;
  });
  // debugData([
  //   {
  //     action: "setLoading",
  //     data: {
  //       status: true
  //     },
  //   }
  // ])

  // debugData([
  //     {
  //         action: "setVisible",
  //         data: {
  //           status: true,
  //           loading: false,
  //           atm: false,
  //           page: 'invoices',
  //           accounts: [
  //             {
  //               id: 'test123',
  //               type: 'personal',
  //               name: 'John Doe',
  //               frozen: false,
  //               amount: 100000,
  //               cash: 100000,
  //               transactions: []
  //             },
  //             {
  //               id: 'test1234',
  //               type: 'Business',
  //               name: 'John Doe',
  //               frozen: false,
  //               amount: 100000,
  //               cash: 100000,
  //               transactions: []
  //             }
  //           ]
  //         },
  //     },
  // ]);

</script>

<svelte:head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" integrity="sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</svelte:head>

<VisibilityProvider>
  {#if $page === "banking"}
  <AccountsContainer />
  {:else if $page === "invoices"}
  <InvoicesContainer />
  {/if}
  {#if $popupDetails.actionType !== ""}
      <Popup />
  {/if}
  {#if $notify !== ""}
      <Notification />
  {/if}
</VisibilityProvider>

{#if $loading}
  <Loading />
{/if}
