<template>
  <div class="suggest">
    {{suggest.Name}} <span class="text-muted">({{suggest.Count}})</span>
  </div>
</template>

<script>
export default {
  name: 'Suggest',
  props: ['suggest']
}
</script>
